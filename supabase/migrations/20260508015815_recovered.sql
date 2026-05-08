CREATE TABLE death_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  person_name TEXT NOT NULL,
  date_of_death DATE NOT NULL,
  time_of_death TIME,
  cause_of_death TEXT,
  place_of_death TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);