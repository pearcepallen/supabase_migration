
BEGIN;

CREATE TABLE public.ref_priority_enum (
  created_at  timestamptz NOT NULL DEFAULT now(),
  name        text,
  color       text,
  uuid        uuid        NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT  ref_priority_enum_pkey PRIMARY KEY (uuid)
);

INSERT INTO public.ref_priority_enum (name) VALUES
  ('High'),
  ('Medium'),
  ('Low');

ALTER TABLE public.hh_deals ADD COLUMN priority__new uuid;

UPDATE public.hh_deals d
SET priority__new = r.uuid
FROM public.ref_priority_enum r
WHERE r.name = d.priority::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.hh_deals
    WHERE priority IS NOT NULL AND priority__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped priority values found in hh_deals — aborting.';
  END IF;
END $$;

ALTER TABLE public.hh_deals DROP COLUMN priority;
ALTER TABLE public.hh_deals RENAME COLUMN priority__new TO priority;

ALTER TABLE public.hh_deals
  ADD CONSTRAINT fk_hh_deals_priority
  FOREIGN KEY (priority) REFERENCES public.ref_priority_enum(uuid);

CREATE INDEX idx_hh_deals_priority ON public.hh_deals(priority);

COMMIT;
;