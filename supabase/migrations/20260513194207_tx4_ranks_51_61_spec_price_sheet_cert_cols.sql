BEGIN;

-- ── Drop views that select cert columns ───────────────────────
DROP VIEW IF EXISTS public.principal_list_product_specs;
DROP VIEW IF EXISTS public.v_spec_price_sheet;

-- ════════════════════════════════════════════════════════════════
-- Single shared ref table for all cert columns (ranks 51-61)
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_specs_certification_options (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_specs_certification_options (name) VALUES
  ('Select updated option'),('Yes - Certified'),('Yes - Not Certified');

-- ── organic (rank 51) ─────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN organic__new uuid;
UPDATE public.spec_price_sheet s SET organic__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.organic::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE organic IS NOT NULL AND organic__new IS NULL) THEN RAISE EXCEPTION 'Rank 51 guard: unmapped organic'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN organic;
ALTER TABLE public.spec_price_sheet RENAME COLUMN organic__new TO organic;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_organic FOREIGN KEY (organic) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_organic ON public.spec_price_sheet(organic);

-- ── non_gmo (rank 52) ─────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN non_gmo__new uuid;
UPDATE public.spec_price_sheet s SET non_gmo__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.non_gmo::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE non_gmo IS NOT NULL AND non_gmo__new IS NULL) THEN RAISE EXCEPTION 'Rank 52 guard: unmapped non_gmo'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN non_gmo;
ALTER TABLE public.spec_price_sheet RENAME COLUMN non_gmo__new TO non_gmo;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_non_gmo FOREIGN KEY (non_gmo) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_non_gmo ON public.spec_price_sheet(non_gmo);

-- ── gluten_free (rank 53) ─────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN gluten_free__new uuid;
UPDATE public.spec_price_sheet s SET gluten_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.gluten_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE gluten_free IS NOT NULL AND gluten_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 53 guard: unmapped gluten_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN gluten_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN gluten_free__new TO gluten_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_gluten_free FOREIGN KEY (gluten_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_gluten_free ON public.spec_price_sheet(gluten_free);

-- ── kosher (rank 54) ──────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN kosher__new uuid;
UPDATE public.spec_price_sheet s SET kosher__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.kosher::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE kosher IS NOT NULL AND kosher__new IS NULL) THEN RAISE EXCEPTION 'Rank 54 guard: unmapped kosher'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN kosher;
ALTER TABLE public.spec_price_sheet RENAME COLUMN kosher__new TO kosher;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_kosher FOREIGN KEY (kosher) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_kosher ON public.spec_price_sheet(kosher);

-- ── vegan (rank 55) ───────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN vegan__new uuid;
UPDATE public.spec_price_sheet s SET vegan__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.vegan::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE vegan IS NOT NULL AND vegan__new IS NULL) THEN RAISE EXCEPTION 'Rank 55 guard: unmapped vegan'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN vegan;
ALTER TABLE public.spec_price_sheet RENAME COLUMN vegan__new TO vegan;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_vegan FOREIGN KEY (vegan) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_vegan ON public.spec_price_sheet(vegan);

-- ── dairy_free (rank 56) ──────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN dairy_free__new uuid;
UPDATE public.spec_price_sheet s SET dairy_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.dairy_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE dairy_free IS NOT NULL AND dairy_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 56 guard: unmapped dairy_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN dairy_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN dairy_free__new TO dairy_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_dairy_free FOREIGN KEY (dairy_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_dairy_free ON public.spec_price_sheet(dairy_free);

-- ── nut_free (rank 57) ────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN nut_free__new uuid;
UPDATE public.spec_price_sheet s SET nut_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.nut_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE nut_free IS NOT NULL AND nut_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 57 guard: unmapped nut_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN nut_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN nut_free__new TO nut_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_nut_free FOREIGN KEY (nut_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_nut_free ON public.spec_price_sheet(nut_free);

-- ── soy_free (rank 58) ────────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN soy_free__new uuid;
UPDATE public.spec_price_sheet s SET soy_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.soy_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE soy_free IS NOT NULL AND soy_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 58 guard: unmapped soy_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN soy_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN soy_free__new TO soy_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_soy_free FOREIGN KEY (soy_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_soy_free ON public.spec_price_sheet(soy_free);

-- ── sugar_free (rank 59) ──────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN sugar_free__new uuid;
UPDATE public.spec_price_sheet s SET sugar_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.sugar_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE sugar_free IS NOT NULL AND sugar_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 59 guard: unmapped sugar_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN sugar_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN sugar_free__new TO sugar_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_sugar_free FOREIGN KEY (sugar_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_sugar_free ON public.spec_price_sheet(sugar_free);

-- ── vegetarian (rank 60) ──────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN vegetarian__new uuid;
UPDATE public.spec_price_sheet s SET vegetarian__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.vegetarian::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE vegetarian IS NOT NULL AND vegetarian__new IS NULL) THEN RAISE EXCEPTION 'Rank 60 guard: unmapped vegetarian'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN vegetarian;
ALTER TABLE public.spec_price_sheet RENAME COLUMN vegetarian__new TO vegetarian;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_vegetarian FOREIGN KEY (vegetarian) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_vegetarian ON public.spec_price_sheet(vegetarian);

-- ── wheat_free (rank 61) ──────────────────────────────────────
ALTER TABLE public.spec_price_sheet ADD COLUMN wheat_free__new uuid;
UPDATE public.spec_price_sheet s SET wheat_free__new = r.uuid FROM public.ref_specs_certification_options r WHERE r.name = s.wheat_free::text;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE wheat_free IS NOT NULL AND wheat_free__new IS NULL) THEN RAISE EXCEPTION 'Rank 61 guard: unmapped wheat_free'; END IF; END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN wheat_free;
ALTER TABLE public.spec_price_sheet RENAME COLUMN wheat_free__new TO wheat_free;
ALTER TABLE public.spec_price_sheet ADD CONSTRAINT fk_sps_wheat_free FOREIGN KEY (wheat_free) REFERENCES public.ref_specs_certification_options(uuid);
CREATE INDEX idx_sps_wheat_free ON public.spec_price_sheet(wheat_free);

-- ════════════════════════════════════════════════════════════════
-- Tracker updates ranks 51-61
-- ════════════════════════════════════════════════════════════════

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. Shared ref_specs_certification_options.'
WHERE priority_rank BETWEEN 51 AND 61;

-- ════════════════════════════════════════════════════════════════
-- Recreate views with all cert cols now uuid
-- ════════════════════════════════════════════════════════════════

CREATE VIEW public.v_spec_price_sheet AS
SELECT
  sps.description, sps.item_status, sps.sales_rank, sps.vendor_item_number,
  sps.upc_12_digit, sps.ean, sps.case_upc, sps.master_upc, sps.case_pack,
  sps.master_pack, sps.unit_height_inches, sps.unit_width_inches, sps.unit_depth_inches,
  sps.case_height_inches, sps.case_width_inches, sps.case_depth_inches,
  sps.master_case_height_inches, sps.master_case_width_inches, sps.master_case_depth_inches,
  sps.net_case_weight_lbs, sps.gross_case_weight_lbs, sps.master_case_weight_lbs,
  sps.ti, sps.hi, sps.cube, sps.cases_per_pallet, sps.pallet_weight_lbs,
  sps.item_temp_reqs, sps.fob_location, sps.srp, sps.direct_ship_available,
  sps.direct_ship_cost_case, sps.fob_price_case, sps.unit_cost_fob,
  sps.delivered_west_distribution_by_case, sps.delivered_east_distribution_by_case,
  sps.minimum_direct_order_quantity, sps.minimum_order_quantity_distribution,
  sps.order_lead_time, sps.shelf_life_in_days_at_manufacture,
  sps.frozen_shelf_life_if_applicable, sps.shelf_life_in_days_guaranteed,
  sps.ingredient_list, sps.other_pricing_case, sps.other_pricing_notes,
  sps.other_pricing_unit, sps.id, sps.brand_id, sps.updated_at, sps.uos, sps.uom,
  sps.unique_item_name, sps.order_lead_time_to_distributor AS order_lead_time_distributor,
  sps.product_shelf_life_slacked_out, sps.best_by_date_indicated,
  sps.organic_certifier_entity,
  sps.organic, sps.non_gmo, sps.gluten_free, sps.vegan, sps.vegetarian,
  sps.kosher, sps.dairy_free, sps.sugar_free, sps.soy_free, sps.nut_free,
  sps.wheat_free, sps.updated_by,
  b.brand AS brand_name,
  sps.updated_at AS last_updated
FROM spec_price_sheet sps
LEFT JOIN brands b ON sps.brand_id = b.id;

CREATE VIEW public.principal_list_product_specs AS
SELECT
  b.id AS brand_id, b.brand, s.id AS product_id,
  s.unique_item_name AS item_name, s.item_status, s.sales_rank, s.uos, s.uom,
  s.vendor_item_number, s.ean, s.upc_12_digit AS upc, s.case_upc, s.master_upc,
  s.case_pack, s.unit_height_inches, s.unit_width_inches, s.unit_depth_inches,
  s.case_height_inches, s.case_width_inches, s.case_depth_inches,
  s.net_case_weight_lbs, s.gross_case_weight_lbs, s.master_case_weight_lbs,
  s.ti, s.hi, s.cube, s.cases_per_pallet, s.pallet_weight_lbs,
  s.item_temp_reqs AS transport, s.fob_location, s.srp, s.direct_ship_available,
  s.minimum_direct_order_quantity AS moq_direct,
  s.minimum_order_quantity_distribution AS moq_distribution,
  s.order_lead_time, s.shelf_life_in_days_at_manufacture,
  s.frozen_shelf_life_if_applicable, s.shelf_life_in_days_guaranteed,
  s.ingredient_list,
  s.organic, s.non_gmo, s.gluten_free, s.vegan, s.vegetarian,
  s.kosher, s.dairy_free, s.sugar_free, s.soy_free, s.nut_free, s.wheat_free
FROM brands b
JOIN spec_price_sheet s ON s.brand_id = b.id;

COMMIT;
