-- Function to calculate distance between two points (without PostGIS)
CREATE OR REPLACE FUNCTION calculate_distance_km(
  lat1 DOUBLE PRECISION,
  lon1 DOUBLE PRECISION,
  lat2 DOUBLE PRECISION,
  lon2 DOUBLE PRECISION
)
RETURNS DOUBLE PRECISION AS $$
DECLARE
  R CONSTANT DOUBLE PRECISION := 6371; -- Earth radius in kilometers
  dlat DOUBLE PRECISION;
  dlon DOUBLE PRECISION;
  a DOUBLE PRECISION;
  c DOUBLE PRECISION;
BEGIN
  dlat := radians(lat2 - lat1);
  dlon := radians(lon2 - lon1);
  a := sin(dlat/2) * sin(dlat/2) + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2) * sin(dlon/2);
  c := 2 * atan2(sqrt(a), sqrt(1-a));
  RETURN R * c;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to get nearby hospitals (without PostGIS)
CREATE OR REPLACE FUNCTION get_nearby_hospitals(
  lat DOUBLE PRECISION,
  long DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 5.0
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  address TEXT,
  phone TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  distance_km DOUBLE PRECISION,
  category TEXT,
  operating_hours JSONB,
  departments TEXT[],
  rating DOUBLE PRECISION,
  review_count INTEGER,
  is_emergency_available BOOLEAN,
  is_parking_available BOOLEAN,
  image_url TEXT
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    h.id,
    h.name,
    h.address,
    h.phone,
    h.latitude,
    h.longitude,
    calculate_distance_km(lat, long, h.latitude, h.longitude) AS distance_km,
    h.category,
    h.operating_hours,
    h.departments,
    h.rating,
    h.review_count,
    h.is_emergency_available,
    h.is_parking_available,
    h.image_url
  FROM public.hospitals h
  WHERE calculate_distance_km(lat, long, h.latitude, h.longitude) <= radius_km
  ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Function to get emergency hospitals
CREATE OR REPLACE FUNCTION get_emergency_hospitals(
  lat DOUBLE PRECISION,
  long DOUBLE PRECISION
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  address TEXT,
  phone TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  distance_km DOUBLE PRECISION,
  category TEXT,
  operating_hours JSONB,
  departments TEXT[],
  rating DOUBLE PRECISION,
  review_count INTEGER,
  is_emergency_available BOOLEAN,
  is_parking_available BOOLEAN,
  image_url TEXT
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    h.id,
    h.name,
    h.address,
    h.phone,
    h.latitude,
    h.longitude,
    calculate_distance_km(lat, long, h.latitude, h.longitude) AS distance_km,
    h.category,
    h.operating_hours,
    h.departments,
    h.rating,
    h.review_count,
    h.is_emergency_available,
    h.is_parking_available,
    h.image_url
  FROM public.hospitals h
  WHERE h.is_emergency_available = TRUE
  ORDER BY distance_km
  LIMIT 10;
END;
$$ LANGUAGE plpgsql;

-- Function to get nearby pharmacies
CREATE OR REPLACE FUNCTION get_nearby_pharmacies(
  lat DOUBLE PRECISION,
  long DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 5.0
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  address TEXT,
  phone TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  distance_km DOUBLE PRECISION,
  operating_hours JSONB,
  is_night_pharmacy BOOLEAN,
  is_holiday_open BOOLEAN,
  rating DOUBLE PRECISION,
  review_count INTEGER,
  image_url TEXT
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.name,
    p.address,
    p.phone,
    p.latitude,
    p.longitude,
    calculate_distance_km(lat, long, p.latitude, p.longitude) AS distance_km,
    p.operating_hours,
    p.is_night_pharmacy,
    p.is_holiday_open,
    p.rating,
    p.review_count,
    p.image_url
  FROM public.pharmacies p
  WHERE calculate_distance_km(lat, long, p.latitude, p.longitude) <= radius_km
  ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Function to add points to user
CREATE OR REPLACE FUNCTION add_points(
  p_user_id UUID,
  p_points INTEGER,
  p_reason TEXT
)
RETURNS VOID AS $$
BEGIN
  -- Update user points
  UPDATE public.users
  SET points = points + p_points
  WHERE id = p_user_id;
  
  -- Insert points history
  INSERT INTO public.points_history (user_id, points, reason)
  VALUES (p_user_id, p_points, p_reason);
  
  -- Check for level up (every 1000 points = 1 level)
  UPDATE public.users
  SET level = GREATEST(1, FLOOR(points / 1000) + 1)
  WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql;