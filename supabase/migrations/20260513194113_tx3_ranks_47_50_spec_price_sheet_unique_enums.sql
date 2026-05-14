BEGIN;

-- ════════════════════════════════════════════════════════════════
-- DROP ALL DEPENDENT VIEWS
-- (will recreate at end of this migration and again after TX4)
-- ════════════════════════════════════════════════════════════════

DROP VIEW IF EXISTS public.principal_list_product_specs;
DROP VIEW IF EXISTS public.v_spec_price_sheet;
DROP VIEW IF EXISTS public.v_brand_promo_requests_with_skus;
DROP VIEW IF EXISTS public.v_brand_promotions_with_skus;
DROP VIEW IF EXISTS public.v_brand_distribution_grid;

-- Drop unique_item_name generated column (depends on uom via format_item_name)
ALTER TABLE public.spec_price_sheet DROP COLUMN unique_item_name;

-- ════════════════════════════════════════════════════════════════
-- RANK 47 — spec_price_sheet.item_status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_item_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_item_status (name) VALUES
  ('Active - Seasonal'),('Active - Year Round'),
  ('Permanently Discontinued'),('Temporarily Inactive');

ALTER TABLE public.spec_price_sheet ADD COLUMN item_status__new uuid;
UPDATE public.spec_price_sheet s SET item_status__new = r.uuid
FROM public.ref_item_status r WHERE r.name = s.item_status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE item_status IS NOT NULL AND item_status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 47 guard: unmapped non-null item_status'; END IF;
END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN item_status;
ALTER TABLE public.spec_price_sheet RENAME COLUMN item_status__new TO item_status;
ALTER TABLE public.spec_price_sheet
  ADD CONSTRAINT fk_spec_price_sheet_item_status
  FOREIGN KEY (item_status) REFERENCES public.ref_item_status(uuid);
CREATE INDEX idx_spec_price_sheet_item_status ON public.spec_price_sheet(item_status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_item_status created and seeded.'
WHERE priority_rank = 47;

-- ════════════════════════════════════════════════════════════════
-- RANK 48 — spec_price_sheet.item_temp_reqs
-- All 21 legacy values preserved as-is
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_transport_enum (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_transport_enum (name) VALUES
  ('1.875lbs'),('Ambient'),('Chill'),('Climate Controlled'),('Cold'),
  ('Cooler'),('Direct Ship Available'),('Dry'),('Dry/Ambient'),('Freezer'),
  ('Frozen'),('Haz-Mat'),('LTL/FTL'),('Refrig'),('Refrigerated'),
  ('Room Temp'),('Shelf Stable'),('Transport'),('Truck'),('YES'),
  ('cool & dry');

ALTER TABLE public.spec_price_sheet ADD COLUMN item_temp_reqs__new uuid;
UPDATE public.spec_price_sheet s SET item_temp_reqs__new = r.uuid
FROM public.ref_transport_enum r WHERE r.name = s.item_temp_reqs::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE item_temp_reqs IS NOT NULL AND item_temp_reqs__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 48 guard: unmapped non-null item_temp_reqs'; END IF;
END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN item_temp_reqs;
ALTER TABLE public.spec_price_sheet RENAME COLUMN item_temp_reqs__new TO item_temp_reqs;
ALTER TABLE public.spec_price_sheet
  ADD CONSTRAINT fk_spec_price_sheet_item_temp_reqs
  FOREIGN KEY (item_temp_reqs) REFERENCES public.ref_transport_enum(uuid);
CREATE INDEX idx_spec_price_sheet_item_temp_reqs ON public.spec_price_sheet(item_temp_reqs);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_transport_enum created and seeded with all 21 values as-is.'
WHERE priority_rank = 48;

-- ════════════════════════════════════════════════════════════════
-- RANK 49 — spec_price_sheet.uom
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_uom_enum (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_uom_enum (name) VALUES
  ('--'),('L'),('ct'),('ea'),('fl oz'),('g'),('gal'),('grams'),
  ('lb'),('liter'),('ml'),('oz'),('pint'),('pk'),('pt'),('qt');

ALTER TABLE public.spec_price_sheet ADD COLUMN uom__new uuid;
UPDATE public.spec_price_sheet s SET uom__new = r.uuid
FROM public.ref_uom_enum r WHERE r.name = s.uom::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE uom IS NOT NULL AND uom__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 49 guard: unmapped non-null uom'; END IF;
END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN uom;
ALTER TABLE public.spec_price_sheet RENAME COLUMN uom__new TO uom;
ALTER TABLE public.spec_price_sheet
  ADD CONSTRAINT fk_spec_price_sheet_uom
  FOREIGN KEY (uom) REFERENCES public.ref_uom_enum(uuid);
CREATE INDEX idx_spec_price_sheet_uom ON public.spec_price_sheet(uom);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_uom_enum created and seeded.'
WHERE priority_rank = 49;

-- ════════════════════════════════════════════════════════════════
-- RANK 50 — spec_price_sheet.best_by_date_indicated
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_best_by_enum (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_best_by_enum (name) VALUES
  ('DD/MM/YY'),('DD/MM/YYYY'),('MM/DD/YY'),('MM/DD/YYYY'),('MM/YY'),('MM/YYYY');

ALTER TABLE public.spec_price_sheet ADD COLUMN best_by_date_indicated__new uuid;
UPDATE public.spec_price_sheet s SET best_by_date_indicated__new = r.uuid
FROM public.ref_best_by_enum r WHERE r.name = s.best_by_date_indicated::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.spec_price_sheet WHERE best_by_date_indicated IS NOT NULL AND best_by_date_indicated__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 50 guard: unmapped non-null best_by_date_indicated'; END IF;
END $$;
ALTER TABLE public.spec_price_sheet DROP COLUMN best_by_date_indicated;
ALTER TABLE public.spec_price_sheet RENAME COLUMN best_by_date_indicated__new TO best_by_date_indicated;
ALTER TABLE public.spec_price_sheet
  ADD CONSTRAINT fk_spec_price_sheet_best_by_date_indicated
  FOREIGN KEY (best_by_date_indicated) REFERENCES public.ref_best_by_enum(uuid);
CREATE INDEX idx_spec_price_sheet_best_by_date_indicated ON public.spec_price_sheet(best_by_date_indicated);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_best_by_enum created and seeded.'
WHERE priority_rank = 50;

-- ════════════════════════════════════════════════════════════════
-- Rewrite format_item_name() — uuid overload
-- Old uom_enum overload retained for spec_price_sheet_migration table
-- ════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.format_item_name(
  description_text text,
  qty              numeric,
  unit_val         uuid
)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  unit_name text;
BEGIN
  SELECT name INTO unit_name FROM public.ref_uom_enum WHERE uuid = unit_val;
  RETURN COALESCE(description_text, '') || ' - ' || COALESCE(qty::text, '') || ' ' || COALESCE(unit_name, '');
END;
$$;

-- ── Recreate unique_item_name generated column ────────────────
ALTER TABLE public.spec_price_sheet
  ADD COLUMN unique_item_name text GENERATED ALWAYS AS (format_item_name(description, uos, uom)) STORED;

-- ════════════════════════════════════════════════════════════════
-- Recreate views
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

CREATE VIEW public.v_brand_promotions_with_skus AS
SELECT
  bp.id, bp.created_at, bp.brand, bp.master_promo_id, bp.retailer_id,
  bp.distribution_id, bp.promo_quarter, bp.submission_status, bp.brand_approval,
  bp.submission_notes, bp.brand_comments, bp.submitted_promo_contracts,
  json_agg(
    jsonb_build_object(
      'id', sps.id, 'unique_item_name', sps.unique_item_name,
      'other_pricing_unit', sps.other_pricing_unit, 'other_pricing_case', sps.other_pricing_case
    )
  ) FILTER (WHERE sps.id IS NOT NULL) AS skus
FROM brand_promotions bp
LEFT JOIN jt_brand_promotion_skus jt ON bp.id = jt.brand_promotion_id
LEFT JOIN spec_price_sheet sps        ON jt.sku_id = sps.id
GROUP BY bp.id;

CREATE VIEW public.v_brand_promo_requests_with_skus AS
SELECT
  bpr.id, bpr.created_at, bpr.brand_id, bpr.retailer_id, bpr.distributor_id,
  bpr.promo_type_brand_facing, bpr.effective_promo_month, bpr.effective_promo_year,
  bpr.submission_status, bpr.brand_approval,
  json_agg(
    CASE WHEN sps.id IS NOT NULL THEN
      jsonb_build_object(
        'id', sps.id, 'unique_item_name', sps.unique_item_name,
        'upc_12_digit', sps.upc_12_digit, 'case_pack', sps.case_pack,
        'fob_price_case', sps.fob_price_case, 'srp', sps.srp
      )
    ELSE NULL::jsonb END
  ) FILTER (WHERE sps.id IS NOT NULL) AS skus,
  COUNT(sps.id) AS sku_count
FROM "brand_promo_requests (Deprecated)" bpr
LEFT JOIN jt_brand_promo_request_skus jt ON bpr.id = jt.brand_promo_request_id
LEFT JOIN spec_price_sheet sps            ON jt.sku_id = sps.id
GROUP BY bpr.id;

CREATE VIEW public.v_brand_distribution_grid AS
SELECT
  bdg.id AS grid_id, bdg.item_code, bdg.distribution_status, bdg.distribution_notes,
  bdg.brand_id, b.brand,
  bdg.item_name AS item_spec_id,
  sps.unique_item_name AS spec_item_name,
  bdg.distributor_hq AS distributor_hq_id,
  dist_acc.account AS distributor_hq_name,
  (
    SELECT string_agg(rc.name, ', ' ORDER BY rc.name)
    FROM jt_accounts_ref_coverage jrc
    JOIN ref_coverage rc ON rc.uuid = jrc.ref_coverage
    WHERE jrc.account = dist_acc.uuid
  ) AS distributor_region,
  bdg.warehouse_dc AS warehouse_dc_id,
  wh_acc.account AS warehouse_dc_name,
  bdg.updated_at AS last_updated,
  bdg.updated_by
FROM brand_distribution_grid bdg
LEFT JOIN brands           b        ON bdg.brand_id       = b.id
LEFT JOIN spec_price_sheet sps      ON bdg.item_name      = sps.id
LEFT JOIN accounts         dist_acc ON bdg.distributor_hq = dist_acc.uuid
LEFT JOIN accounts         wh_acc   ON bdg.warehouse_dc   = wh_acc.uuid;

COMMIT;
