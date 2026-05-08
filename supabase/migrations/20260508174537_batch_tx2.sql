
-- ref_deal_stage already seeded above — ON CONFLICT is safe
INSERT INTO public.ref_deal_stage (name) VALUES
  ('Target'), ('Presenting'), ('Active'), ('Passed')
ON CONFLICT DO NOTHING;

-- ── hh_deals.stage ────────────────────────────────────────────────────────────

ALTER TABLE public.hh_deals ALTER COLUMN stage DROP DEFAULT;

ALTER TABLE public.hh_deals ADD COLUMN stage__new uuid;

UPDATE public.hh_deals t
SET stage__new = r.uuid
FROM public.ref_deal_stage r
WHERE t.stage::text = r.name;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.hh_deals
    WHERE stage__new IS NULL AND stage IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped rows in hh_deals.stage — aborting.';
  END IF;
END $$;

ALTER TABLE public.hh_deals DROP COLUMN stage;
ALTER TABLE public.hh_deals RENAME COLUMN stage__new TO stage;

-- Set UUID default using the concrete value for 'Target'
ALTER TABLE public.hh_deals
  ALTER COLUMN stage SET DEFAULT 'b60b2f13-2af3-43b5-b085-1adb0eb85c7d'::uuid;

ALTER TABLE public.hh_deals
  ADD CONSTRAINT fk_hh_deals_stage
    FOREIGN KEY (stage) REFERENCES public.ref_deal_stage(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_hh_deals_stage ON public.hh_deals (stage);
;