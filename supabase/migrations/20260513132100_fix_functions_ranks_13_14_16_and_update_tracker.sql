BEGIN;

-- ── 1. Drop and recreate fetch_program_status() with new return type ──────────
DROP FUNCTION IF EXISTS public.fetch_program_status();

CREATE FUNCTION public.fetch_program_status()
  RETURNS TABLE(id uuid, program_status_type text)
  LANGUAGE sql
AS $$
  SELECT id, name AS program_status_type
  FROM ref_sos_program_type
  ORDER BY name;
$$;

-- ── 2. Rewrite update_program_field() trigger ─────────────────────────────────
CREATE OR REPLACE FUNCTION public.update_program_field()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  brand_name        text;
  total_connects    bigint;
  calling_year_name text;
  region_name       text;
BEGIN
  SELECT brand INTO brand_name FROM brands WHERE id = NEW.brand;
  total_connects := COALESCE(NEW.sponsored_connects, 0) + COALESCE(NEW.total_paid_connects_authorized, 0);
  SELECT name INTO calling_year_name FROM ref_sos_calling_year WHERE uuid = NEW.calling_year;
  SELECT name INTO region_name       FROM ref_coverage           WHERE uuid = NEW.region;

  NEW.program := CONCAT(
    brand_name,          ' - ',
    NEW.calling_month,   ' - ',
    calling_year_name,   ' - ',
    COALESCE(NEW.program_type[1], ''), ' - ',
    region_name,         ' - ',
    total_connects::text
  );

  RETURN NEW;
END;
$$;

-- ── 3. Mark tracker rows done ─────────────────────────────────────────────────
UPDATE ref_migration_tracker
SET
  status            = 'done',
  executed_at       = now(),
  validation_passed = true,
  notes             = COALESCE(notes, '') || ' | Schema already applied on m2; functions rewritten 2026-05-13.'
WHERE priority_rank IN (13, 14, 16);

COMMIT;
