-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Users table (extends Supabase Auth)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  phone TEXT,
  profile_image_url TEXT,
  birth_date DATE,
  gender TEXT CHECK (gender IN ('male', 'female', 'other', NULL)),
  points INTEGER DEFAULT 0 CHECK (points >= 0),
  level INTEGER DEFAULT 1 CHECK (level >= 1),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hospitals table
CREATE TABLE IF NOT EXISTS public.hospitals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  location GEOGRAPHY(POINT, 4326),
  category TEXT,
  operating_hours JSONB,
  departments TEXT[],
  rating DOUBLE PRECISION CHECK (rating >= 0 AND rating <= 5),
  review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
  is_emergency_available BOOLEAN DEFAULT FALSE,
  is_parking_available BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Pharmacies table
CREATE TABLE IF NOT EXISTS public.pharmacies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  location GEOGRAPHY(POINT, 4326),
  operating_hours JSONB,
  is_night_pharmacy BOOLEAN DEFAULT FALSE,
  is_holiday_open BOOLEAN DEFAULT FALSE,
  rating DOUBLE PRECISION CHECK (rating >= 0 AND rating <= 5),
  review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Medicines table
CREATE TABLE IF NOT EXISTS public.medicines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  manufacturer TEXT,
  category TEXT,
  ingredients TEXT[],
  effects TEXT,
  usage_instructions TEXT,
  side_effects TEXT,
  warnings TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User favorite hospitals
CREATE TABLE IF NOT EXISTS public.user_favorite_hospitals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  hospital_id UUID NOT NULL REFERENCES public.hospitals(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, hospital_id)
);

-- User favorite pharmacies
CREATE TABLE IF NOT EXISTS public.user_favorite_pharmacies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  pharmacy_id UUID NOT NULL REFERENCES public.pharmacies(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, pharmacy_id)
);

-- Points history
CREATE TABLE IF NOT EXISTS public.points_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  points INTEGER NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_hospitals_location ON public.hospitals USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_pharmacies_location ON public.pharmacies USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_user_favorite_hospitals_user_id ON public.user_favorite_hospitals(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorite_pharmacies_user_id ON public.user_favorite_pharmacies(user_id);
CREATE INDEX IF NOT EXISTS idx_points_history_user_id ON public.points_history(user_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hospitals_updated_at BEFORE UPDATE ON public.hospitals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pharmacies_updated_at BEFORE UPDATE ON public.pharmacies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_medicines_updated_at BEFORE UPDATE ON public.medicines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to update location column
CREATE OR REPLACE FUNCTION update_hospital_location()
RETURNS TRIGGER AS $$
BEGIN
  NEW.location = ST_MakePoint(NEW.longitude, NEW.latitude)::geography;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_pharmacy_location()
RETURNS TRIGGER AS $$
BEGIN
  NEW.location = ST_MakePoint(NEW.longitude, NEW.latitude)::geography;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for location updates
CREATE TRIGGER update_hospital_location_trigger
  BEFORE INSERT OR UPDATE OF latitude, longitude ON public.hospitals
  FOR EACH ROW EXECUTE FUNCTION update_hospital_location();

CREATE TRIGGER update_pharmacy_location_trigger
  BEFORE INSERT OR UPDATE OF latitude, longitude ON public.pharmacies
  FOR EACH ROW EXECUTE FUNCTION update_pharmacy_location();

-- Function to get nearby hospitals
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
    ST_Distance(h.location, ST_MakePoint(long, lat)::geography) / 1000 AS distance_km,
    h.category,
    h.operating_hours,
    h.departments,
    h.rating,
    h.review_count,
    h.is_emergency_available,
    h.is_parking_available,
    h.image_url
  FROM public.hospitals h
  WHERE ST_DWithin(h.location, ST_MakePoint(long, lat)::geography, radius_km * 1000)
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
    ST_Distance(h.location, ST_MakePoint(long, lat)::geography) / 1000 AS distance_km,
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
    ST_Distance(p.location, ST_MakePoint(long, lat)::geography) / 1000 AS distance_km,
    p.operating_hours,
    p.is_night_pharmacy,
    p.is_holiday_open,
    p.rating,
    p.review_count,
    p.image_url
  FROM public.pharmacies p
  WHERE ST_DWithin(p.location, ST_MakePoint(long, lat)::geography, radius_km * 1000)
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