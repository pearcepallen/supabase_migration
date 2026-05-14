BEGIN;

-- ════════════════════════════════════════════════════════════════
-- RANK 44 — sample_shipment_tracking.status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_sample_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_sample_status (name) VALUES
  ('feedback'),('not_sent'),('received'),('sent');

ALTER TABLE public.sample_shipment_tracking ADD COLUMN status__new uuid;
UPDATE public.sample_shipment_tracking s SET status__new = r.uuid
FROM public.ref_sample_status r WHERE r.name = s.status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.sample_shipment_tracking WHERE status IS NOT NULL AND status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 44 guard: unmapped non-null status in sample_shipment_tracking'; END IF;
END $$;
ALTER TABLE public.sample_shipment_tracking DROP COLUMN status;
ALTER TABLE public.sample_shipment_tracking RENAME COLUMN status__new TO status;
ALTER TABLE public.sample_shipment_tracking
  ADD CONSTRAINT fk_sample_shipment_tracking_status
  FOREIGN KEY (status) REFERENCES public.ref_sample_status(uuid);
CREATE INDEX idx_sample_shipment_tracking_status ON public.sample_shipment_tracking(status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_sample_status created and seeded.'
WHERE priority_rank = 44;

-- ════════════════════════════════════════════════════════════════
-- RANK 45 — sample_shipment_tracking.carrier
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_ship_carrier (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_ship_carrier (name) VALUES
  ('dhl'),('fedex'),('other'),('ups'),('usps');

ALTER TABLE public.sample_shipment_tracking ADD COLUMN carrier__new uuid;
UPDATE public.sample_shipment_tracking s SET carrier__new = r.uuid
FROM public.ref_ship_carrier r WHERE r.name = s.carrier::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.sample_shipment_tracking WHERE carrier IS NOT NULL AND carrier__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 45 guard: unmapped non-null carrier in sample_shipment_tracking'; END IF;
END $$;
ALTER TABLE public.sample_shipment_tracking DROP COLUMN carrier;
ALTER TABLE public.sample_shipment_tracking RENAME COLUMN carrier__new TO carrier;
ALTER TABLE public.sample_shipment_tracking
  ADD CONSTRAINT fk_sample_shipment_tracking_carrier
  FOREIGN KEY (carrier) REFERENCES public.ref_ship_carrier(uuid);
CREATE INDEX idx_sample_shipment_tracking_carrier ON public.sample_shipment_tracking(carrier);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_ship_carrier created and seeded.'
WHERE priority_rank = 45;

-- ════════════════════════════════════════════════════════════════
-- RANK 46 — sku_placements.sku_status
-- Note: 'NULL' is a live string enum value, not a real null
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_sku_deal_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_sku_deal_status (name) VALUES
  ('Active'),('NULL'),('Pursuing'),('Rejected');

ALTER TABLE public.sku_placements ADD COLUMN sku_status__new uuid;
UPDATE public.sku_placements s SET sku_status__new = r.uuid
FROM public.ref_sku_deal_status r WHERE r.name = s.sku_status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.sku_placements WHERE sku_status IS NOT NULL AND sku_status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 46 guard: unmapped non-null sku_status in sku_placements'; END IF;
END $$;
ALTER TABLE public.sku_placements DROP COLUMN sku_status;
ALTER TABLE public.sku_placements RENAME COLUMN sku_status__new TO sku_status;
ALTER TABLE public.sku_placements
  ADD CONSTRAINT fk_sku_placements_sku_status
  FOREIGN KEY (sku_status) REFERENCES public.ref_sku_deal_status(uuid);
CREATE INDEX idx_sku_placements_sku_status ON public.sku_placements(sku_status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_sku_deal_status created and seeded. NULL string value preserved as-is.'
WHERE priority_rank = 46;

COMMIT;
