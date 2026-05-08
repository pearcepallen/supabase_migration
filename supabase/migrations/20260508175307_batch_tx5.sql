
-- ── CREATE ref_sos_calling_month (does not exist yet) ─────────────────────────

CREATE TABLE IF NOT EXISTS public.ref_sos_calling_month (
  uuid       uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL    DEFAULT now(),
  name       text,
  color      text
);

-- ── SEED all 4 ref tables ─────────────────────────────────────────────────────

INSERT INTO public.ref_sos_calling_month (name) VALUES
  ('January'),('February'),('March'),('April'),('May'),('June'),
  ('July'),('August'),('September'),('October'),('November'),('December')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_sos_calling_year (name) VALUES
  ('2023'),('2024'),('2025'),('2026'),('2027')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_coverage (name) VALUES
  ('Alaska'),('Hawaii'),('Intermountain West'),('MidAtlantic'),('Midwest'),
  ('Northeast'),('Northern California'),('Pacific Northwest'),('Rocky Mountain'),
  ('South'),('Southern California'),('Texas and South Central'),('International - Other'),
  ('National'),('Asia'),('Canada'),('International'),('West'),('East'),
  ('Pacific NW'),('Central'),('SoCal'),('NorCal'),('PNW'),
  ('Idaho'),('Montana'),('Southeast'),('Texas/Central'),('Mid-Atlantic'),
  ('Intermountain'),('Oregon'),('Michigan')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_sos_program_type (name) VALUES
  ('Active/Placeholder'),('GNF Input Needed'),('SOS Input Needed'),('Planning Meeting Set'),
  ('List Generation'),('Call Plan Ready'),('Calls In Progress'),('Calls Completed'),
  ('Report Sent'),('Invoiced/Closed'),('GNF Sponsored/Closed'),('Not Completed'),
  ('No Program Needed'),('List Being Generated'),('Campaign Planning Needed')
ON CONFLICT DO NOTHING;

-- ── DROP 3 dependent views ────────────────────────────────────────────────────

DROP VIEW IF EXISTS public.v_sos_authorizations_extended;
DROP VIEW IF EXISTS public.v_sos_authorizations_with_calculated_revenue;
DROP VIEW IF EXISTS public.v_program_connects_by_month;

-- ── sos_authorizations.program_status ────────────────────────────────────────
-- ref_sos_program_type uses id (uuid PK) — not uuid column

ALTER TABLE public.sos_authorizations ADD COLUMN program_status__new uuid;

UPDATE public.sos_authorizations t
SET program_status__new = r.id
FROM public.ref_sos_program_type r
WHERE t.program_status::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.sos_authorizations WHERE program_status__new IS NULL AND program_status IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in sos_authorizations.program_status — aborting.';
  END IF;
END $$;

ALTER TABLE public.sos_authorizations DROP COLUMN program_status;
ALTER TABLE public.sos_authorizations RENAME COLUMN program_status__new TO program_status;

ALTER TABLE public.sos_authorizations
  ADD CONSTRAINT fk_sos_authorizations_program_status
    FOREIGN KEY (program_status) REFERENCES public.ref_sos_program_type(id)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_sos_authorizations_program_status ON public.sos_authorizations (program_status);

-- ── sos_authorizations.region ─────────────────────────────────────────────────
-- ref_coverage uses uuid (PK)

ALTER TABLE public.sos_authorizations ADD COLUMN region__new uuid;

UPDATE public.sos_authorizations t
SET region__new = r.uuid
FROM public.ref_coverage r
WHERE t.region::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.sos_authorizations WHERE region__new IS NULL AND region IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in sos_authorizations.region — aborting.';
  END IF;
END $$;

ALTER TABLE public.sos_authorizations DROP COLUMN region;
ALTER TABLE public.sos_authorizations RENAME COLUMN region__new TO region;

ALTER TABLE public.sos_authorizations
  ADD CONSTRAINT fk_sos_authorizations_region
    FOREIGN KEY (region) REFERENCES public.ref_coverage(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_sos_authorizations_region ON public.sos_authorizations (region);

-- ── sos_authorizations.calling_month ─────────────────────────────────────────

ALTER TABLE public.sos_authorizations ADD COLUMN calling_month__new uuid;

UPDATE public.sos_authorizations t
SET calling_month__new = r.uuid
FROM public.ref_sos_calling_month r
WHERE t.calling_month::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.sos_authorizations WHERE calling_month__new IS NULL AND calling_month IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in sos_authorizations.calling_month — aborting.';
  END IF;
END $$;

ALTER TABLE public.sos_authorizations DROP COLUMN calling_month;
ALTER TABLE public.sos_authorizations RENAME COLUMN calling_month__new TO calling_month;

ALTER TABLE public.sos_authorizations
  ADD CONSTRAINT fk_sos_authorizations_calling_month
    FOREIGN KEY (calling_month) REFERENCES public.ref_sos_calling_month(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_sos_authorizations_calling_month ON public.sos_authorizations (calling_month);

-- ── sos_authorizations.calling_year ──────────────────────────────────────────

ALTER TABLE public.sos_authorizations ADD COLUMN calling_year__new uuid;

UPDATE public.sos_authorizations t
SET calling_year__new = r.uuid
FROM public.ref_sos_calling_year r
WHERE t.calling_year::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.sos_authorizations WHERE calling_year__new IS NULL AND calling_year IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in sos_authorizations.calling_year — aborting.';
  END IF;
END $$;

ALTER TABLE public.sos_authorizations DROP COLUMN calling_year;
ALTER TABLE public.sos_authorizations RENAME COLUMN calling_year__new TO calling_year;

ALTER TABLE public.sos_authorizations
  ADD CONSTRAINT fk_sos_authorizations_calling_year
    FOREIGN KEY (calling_year) REFERENCES public.ref_sos_calling_year(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_sos_authorizations_calling_year ON public.sos_authorizations (calling_year);

-- ── RECREATE v_sos_authorizations_extended ────────────────────────────────────
-- program_status, calling_month, calling_year, region are now uuid — selected as-is

CREATE OR REPLACE VIEW public.v_sos_authorizations_extended AS
SELECT
  sa.id, sa.created_at,
  sa.brand AS brand_id,
  sa.program_type,
  sa.program_status,
  sa.calling_month,
  sa.calling_year,
  sa.region,
  sa.goodnow_input,
  sa.program_calling_goals,
  sa.sponsored_connects,
  sa.total_paid_connects_authorized,
  sa.date_billed,
  sa.sos_rep_assigned AS sos_rep_assigned_id,
  sa.calling_lists_from_vendor,
  sa.program,
  sa.connects_achieved,
  b.brand AS brand_name,
  tmg.name AS rep_name,
  tmg.profile_photo AS rep_profile_photo
FROM public.sos_authorizations sa
LEFT JOIN public.brands b ON sa.brand = b.id
LEFT JOIN public.team_member_guide tmg ON sa.sos_rep_assigned = tmg.uuid;

-- ── RECREATE v_sos_authorizations_with_calculated_revenue ────────────────────

CREATE OR REPLACE VIEW public.v_sos_authorizations_with_calculated_revenue AS
SELECT
  sa.id, sa.created_at, sa.brand, sa.program_type, sa.program_status,
  sa.calling_month, sa.calling_year, sa.region,
  sa.goodnow_input, sa.program_calling_goals, sa.sponsored_connects,
  sa.total_paid_connects_authorized, sa.date_billed, sa.sos_rep_assigned,
  sa.calling_lists_from_vendor, sa.program, sa.connects_achieved,
  b.brand AS brand_name,
  b.sos_sales_rate::numeric AS sos_sales_rate,
  b.sos_sales_rate::numeric * (sa.connects_achieved::numeric - sa.sponsored_connects::numeric) AS sos_revenue
FROM public.sos_authorizations sa
JOIN public.brands b ON sa.brand = b.id;

-- ── RECREATE v_program_connects_by_month ─────────────────────────────────────
-- calling_month and calling_year are now uuid — concat uses ref joins for display

CREATE OR REPLACE VIEW public.v_program_connects_by_month AS
SELECT
  sa.id AS sos_authorization_id,
  b.brand AS brand_name,
  sa.calling_month,
  sa.calling_year,
  sum(COALESCE(at.connect_count, 0)) AS connects_achieved,
  concat(
    b.brand, ' - ',
    rcm.name, ' - ',
    rcy.name, ' - ',
    sum(COALESCE(at.connect_count, 0))
  ) AS program_summary_name
FROM public.sos_authorizations sa
LEFT JOIN public.activity_tracker at ON at.sos_authorizations = sa.id
LEFT JOIN public.brands b ON sa.brand = b.id
LEFT JOIN public.ref_sos_calling_month rcm ON rcm.uuid = sa.calling_month
LEFT JOIN public.ref_sos_calling_year  rcy ON rcy.uuid  = sa.calling_year
WHERE at.connect_stage::text ILIKE 'Connect%'
GROUP BY sa.id, b.brand, sa.calling_month, sa.calling_year, rcm.name, rcy.name;
;