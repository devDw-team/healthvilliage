-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pharmacies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medicines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorite_hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorite_pharmacies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.points_history ENABLE ROW LEVEL SECURITY;

-- Users table policies
-- Users can view their own profile
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile (during signup)
CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Hospitals table policies
-- Anyone can view hospitals (public data)
CREATE POLICY "Public can view hospitals" ON public.hospitals
  FOR SELECT USING (true);

-- Only admins can insert/update/delete hospitals
CREATE POLICY "Admins can manage hospitals" ON public.hospitals
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND email LIKE '%@admin.healthvillage.com'
    )
  );

-- Pharmacies table policies
-- Anyone can view pharmacies (public data)
CREATE POLICY "Public can view pharmacies" ON public.pharmacies
  FOR SELECT USING (true);

-- Only admins can insert/update/delete pharmacies
CREATE POLICY "Admins can manage pharmacies" ON public.pharmacies
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND email LIKE '%@admin.healthvillage.com'
    )
  );

-- Medicines table policies
-- Anyone can view medicines (public data)
CREATE POLICY "Public can view medicines" ON public.medicines
  FOR SELECT USING (true);

-- Only admins can insert/update/delete medicines
CREATE POLICY "Admins can manage medicines" ON public.medicines
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND email LIKE '%@admin.healthvillage.com'
    )
  );

-- User favorite hospitals policies
-- Users can view their own favorites
CREATE POLICY "Users can view own favorite hospitals" ON public.user_favorite_hospitals
  FOR SELECT USING (auth.uid() = user_id);

-- Users can add their own favorites
CREATE POLICY "Users can add own favorite hospitals" ON public.user_favorite_hospitals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can delete their own favorites
CREATE POLICY "Users can delete own favorite hospitals" ON public.user_favorite_hospitals
  FOR DELETE USING (auth.uid() = user_id);

-- User favorite pharmacies policies
-- Users can view their own favorites
CREATE POLICY "Users can view own favorite pharmacies" ON public.user_favorite_pharmacies
  FOR SELECT USING (auth.uid() = user_id);

-- Users can add their own favorites
CREATE POLICY "Users can add own favorite pharmacies" ON public.user_favorite_pharmacies
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can delete their own favorites
CREATE POLICY "Users can delete own favorite pharmacies" ON public.user_favorite_pharmacies
  FOR DELETE USING (auth.uid() = user_id);

-- Points history policies
-- Users can view their own points history
CREATE POLICY "Users can view own points history" ON public.points_history
  FOR SELECT USING (auth.uid() = user_id);

-- Only system can insert points history (through functions)
-- No direct insert policy for users

-- Create function to handle user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();