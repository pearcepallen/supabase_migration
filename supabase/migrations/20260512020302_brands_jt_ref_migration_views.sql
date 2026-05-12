
BEGIN;

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 1: Drop dependents in reverse dependency order
-- ─────────────────────────────────────────────────────────────────────────────
DROP VIEW     IF EXISTS public.v_dashboard_summary;
DROP FUNCTION IF EXISTS public.get_next_category_review_deadline();
DROP VIEW     IF EXISTS public.v_brand_matching;
DROP VIEW     IF EXISTS public.brand_status_analytics;
DROP VIEW     IF EXISTS public.brands_by_region;
DROP VIEW     IF EXISTS public.v_brands_focus;
DROP VIEW     IF EXISTS public.v_brands_needing_attention;
DROP VIEW     IF EXISTS public.v_brands_view;

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 2: Rename deprecated enum columns on brands
-- ─────────────────────────────────────────────────────────────────────────────
ALTER TABLE public.brands RENAME COLUMN status          TO status_deprecated;
ALTER TABLE public.brands RENAME COLUMN services        TO services_deprecated;
ALTER TABLE public.brands RENAME COLUMN coverage        TO coverage_deprecated;
ALTER TABLE public.brands RENAME COLUMN attention_flags TO attention_flags_deprecated;

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 3: Recreate views
-- ─────────────────────────────────────────────────────────────────────────────

-- 3a. brand_status_analytics
CREATE OR REPLACE VIEW public.brand_status_analytics AS
WITH unnested_statuses AS (
  SELECT b.id, b.brand, rs.name AS status
  FROM brands b
  JOIN jt_ref_brand_status jbs ON jbs.brands     = b.id
  JOIN ref_brand_status    rs  ON rs.id           = jbs.ref_brand_status
),
status_categories AS (
  SELECT
    u.id, u.brand, u.status,
    CASE
      WHEN u.status = ANY (ARRAY['Active','Priority','Demo Program - Depricated','SOS Program - Depricated'])
        THEN 'Active/Healthy'
      WHEN u.status = ANY (ARRAY['Onboarding','New to Market'])
        THEN 'Onboarding'
      WHEN u.status = ANY (ARRAY['Sustaining (Commission)','Commission','Low Comm - Depricated','Private Label - Depricated','Special'])
        THEN 'Commission/Special'
      WHEN u.status = ANY (ARRAY['Pause time TBD - Depricated','Demo Request Time Off','Pause TBD','In Cancellation'])
        THEN 'At Risk/Paused'
      WHEN u.status = ANY (ARRAY['Former GoodNow Vendor','Former Demo Vendor','Former SOS Vendor'])
        THEN 'Former/Inactive'
      WHEN u.status = 'Prospect' THEN 'Prospect'
      ELSE 'Other'
    END AS status_category,
    CASE
      WHEN u.status = ANY (ARRAY['Active','Priority','Demo Program - Depricated','SOS Program - Depricated','Onboarding','New to Market','Sustaining (Commission)','Commission','Low Comm - Depricated','Private Label - Depricated','Special'])
        THEN 1
      WHEN u.status = ANY (ARRAY['Pause time TBD - Depricated','Demo Request Time Off','Pause TBD','In Cancellation','Prospect'])
        THEN 2
      WHEN u.status = ANY (ARRAY['Former GoodNow Vendor','Former Demo Vendor','Former SOS Vendor'])
        THEN 3
      ELSE 4
    END AS health_score
  FROM unnested_statuses u
)
SELECT
  sc.status, sc.status_category, sc.health_score,
  COUNT(DISTINCT sc.id) AS brand_count,
  ROUND((100.0 * COUNT(DISTINCT sc.id)::numeric) / SUM(COUNT(DISTINCT sc.id)) OVER (), 2) AS percentage
FROM status_categories sc
GROUP BY sc.status, sc.status_category, sc.health_score
ORDER BY sc.health_score, sc.status_category, COUNT(DISTINCT sc.id) DESC;


-- 3b. brands_by_region
CREATE OR REPLACE VIEW public.brands_by_region AS
SELECT rc.name AS region, COUNT(b.id) AS brand_count
FROM brands b
JOIN jt_ref_coverage jc ON jc.brands = b.id
JOIN ref_coverage    rc ON rc.uuid   = jc.ref_coverage
GROUP BY rc.name
ORDER BY COUNT(b.id) DESC;


-- 3c. v_brands_focus
CREATE OR REPLACE VIEW public.v_brands_focus AS
SELECT
  bfa.id AS assignment_id,
  b.brand AS brand_name,
  (
    SELECT COALESCE(array_agg(rc.name ORDER BY rc.name), ARRAY[]::text[])
    FROM jt_ref_coverage jc
    JOIN ref_coverage rc ON rc.uuid = jc.ref_coverage
    WHERE jc.brands = b.id
  ) AS coverage,
  tmg.name AS team_member_name,
  tmg.profile_photo,
  bfa.focus_month,
  bfa."Notes" AS notes,
  bfa.created_at
FROM brand_focus_assignments bfa
JOIN brands b             ON bfa.brand       = b.id
JOIN team_member_guide tmg ON bfa.team_member = tmg.uuid
WHERE EXISTS (
  SELECT 1
  FROM jt_ref_active_services jas
  JOIN ref_active_services    ras ON ras.uuid = jas.ref_active_services
  WHERE jas.brands = b.id AND ras.name = 'GoodNow'
);


-- 3d. v_brands_needing_attention
CREATE OR REPLACE VIEW public.v_brands_needing_attention AS
SELECT
  b.brand,
  COALESCE(
    jsonb_agg(jsonb_build_object('id', raf.uuid, 'name', raf.name, 'color', raf.color) ORDER BY raf.name)
    FILTER (WHERE raf.uuid IS NOT NULL),
    '[]'::jsonb
  ) AS attention_flags
FROM brands b
JOIN jt_ref_brand_attention_flag         jbaf ON jbaf.brands = b.id
JOIN ref_account_flag_for_attention_enum raf  ON raf.uuid    = jbaf.ref_brand_attention_flag
GROUP BY b.id, b.brand
HAVING COUNT(raf.uuid) > 0;


-- 3e. v_brands_view
CREATE OR REPLACE VIEW public.v_brands_view AS
SELECT
  b.id, b.brand, b.manufacturer_name, b.principal_list_status,
  b.start_date, b.last_date, b.sos_start_date, b.demo_start_date,
  b.headquarters_address, b.mailing_address_if_different,
  b.free_fill_placement_authorization, b.samples_policy_and_request_process,
  b.mission_components, b.overall_brand_goals, b.demos_included_quarterly,
  b.sos_calls_included_monthly, b.sos_sales_rate, b.referred_by,
  b.product_pickup_address, b.product_summary, b.se___current_month,
  b.invoice_timing, b.billing_notes, b.tax_id_number,
  b.private_label_bulk_and__or_food_service,
  b.describe_any_capabilities_from_the_selection_above,
  b.order_lead_time, b.full_reclamation_or_spoils_allowance,
  b.brand_certifications, b.capacity_or_production_restrictions,
  b.direct_order_details_process, b.marketing_descriptions,
  b.email_pitch_descriptor, b.are_you_a_member_of_any_trade_organizations,
  b.product_attributes, b.onboarding_notes, b.company_website,
  b.cancellation_reasons, b.se___next_month, b.brand_contracts,
  b.follow_up_email_draft, b.category_for_principal_list,
  b.product_sub_category_for_principal_list, b.new_item, b.product_images,
  b.brand_logo, b.other_active_brokerage_service_coverage, b.demo_customer_type,
  b.faire_link, b.mable_link, b.airgoods_link, b.other_link, b.pod_foods_link,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', rs.id,   'name', rs.name,   'color', rs.color))  FILTER (WHERE rs.id   IS NOT NULL), '[]'::jsonb) AS status,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', ras.uuid,'name', ras.name,  'color', ras.color)) FILTER (WHERE ras.uuid IS NOT NULL), '[]'::jsonb) AS services,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', rc.uuid, 'name', rc.name,   'color', rc.color))  FILTER (WHERE rc.uuid  IS NOT NULL), '[]'::jsonb) AS coverage,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', raf.uuid,'name', raf.name,  'color', raf.color)) FILTER (WHERE raf.uuid IS NOT NULL), '[]'::jsonb) AS attention_flags,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', d.id,   'name', d.name, 'size', d.size, 'path', d.storage_path)) FILTER (WHERE d.id IS NOT NULL), '[]'::jsonb) AS principal_list_images,
  COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', mc.id,  'name', mc.full_category)) FILTER (WHERE mc.id IS NOT NULL), '[]'::jsonb) AS master_categories
FROM brands b
LEFT JOIN jt_ref_brand_status                 jbs   ON jbs.brands              = b.id
LEFT JOIN ref_brand_status                    rs    ON rs.id                   = jbs.ref_brand_status
LEFT JOIN jt_ref_active_services              jas   ON jas.brands              = b.id
LEFT JOIN ref_active_services                 ras   ON ras.uuid                = jas.ref_active_services
LEFT JOIN jt_ref_coverage                     jc    ON jc.brands               = b.id
LEFT JOIN ref_coverage                        rc    ON rc.uuid                 = jc.ref_coverage
LEFT JOIN jt_ref_brand_attention_flag         jbaf  ON jbaf.brands             = b.id
LEFT JOIN ref_account_flag_for_attention_enum raf   ON raf.uuid                = jbaf.ref_brand_attention_flag
LEFT JOIN jt_principal_list_product_images    jt    ON jt.brand                = b.id
LEFT JOIN brand_documents                     d     ON jt.brand_document_id    = d.id
LEFT JOIN jt_master_categories_brands         jt_mc ON jt_mc.brand_id          = b.id
LEFT JOIN master_categories                   mc    ON jt_mc.master_category_id = mc.id
GROUP BY b.id;


-- 3f. v_brand_matching
CREATE OR REPLACE VIEW public.v_brand_matching AS
WITH aggregated_managers AS (
  SELECT
    jccm.master_category_review_id AS review_id,
    array_agg(DISTINCT c.uuid) FILTER (WHERE c.uuid IS NOT NULL) AS manager_ids,
    jsonb_agg(jsonb_build_object('id', c.uuid, 'name', c.full_name, 'email', c.contact_email, 'phone', c.contact_phone, 'title', c.job_title)) AS managers_list
  FROM jt_contacts_categories_managed jccm
  JOIN contacts c ON c.uuid = jccm.contact_id
  GROUP BY jccm.master_category_review_id
),
aggregated_brands AS (
  SELECT
    link.review_id,
    COUNT(link.id) AS brand_count,
    jsonb_agg(
      jsonb_build_object(
        'match_id', link.id, 'brand_id', b.id, 'brand_name', b.brand,
        'brand_logo', b.brand_logo, 'manufacturer_name', b.manufacturer_name,
        'brand_status', (
          SELECT COALESCE(array_agg(rs.name ORDER BY rs.name), ARRAY[]::text[])
          FROM jt_ref_brand_status jbs
          JOIN ref_brand_status rs ON rs.id = jbs.ref_brand_status
          WHERE jbs.brands = b.id
        ),
        'matched_on', link.created_at
      ) ORDER BY b.brand
    ) AS brands_array,
    MAX(mc_1.updated_at) AS category_updated_at
  FROM jt_matched_brands_to_category_reviews link
  JOIN jt_master_categories_brands jmc  ON link.brand_match_id     = jmc.id
  JOIN brands                      b    ON jmc.brand_id            = b.id
  JOIN master_categories           mc_1 ON jmc.master_category_id  = mc_1.id
  GROUP BY link.review_id
)
SELECT
  r.id AS review_id, r.master_category_id AS category_id,
  COALESCE(r.display_name, r.retailer_category, 'Unnamed Review') AS review_name,
  r.review_type, r.retailer_review_timing, r.new_item_submission_deadline,
  r.on_shelf_reset_date, r.archive AS is_archived,
  mc.full_category, mc.subcategory, mc.category AS category_type,
  COALESCE(ab.brands_array, '[]'::jsonb)    AS linked_brands_array,
  COALESCE(ab.brand_count, 0::bigint)       AS linked_brands_count,
  COALESCE(am.manager_ids, ARRAY[]::uuid[]) AS filter_manager_ids,
  COALESCE(am.managers_list, '[]'::jsonb)   AS category_managers,
  GREATEST(r.updated_at, ab.category_updated_at) AS last_modified
FROM master_category_review_data r
LEFT JOIN master_categories   mc ON r.master_category_id = mc.id
JOIN  aggregated_brands       ab ON r.id = ab.review_id
LEFT JOIN aggregated_managers am ON r.id = am.review_id;


-- 3g. get_next_category_review_deadline
CREATE OR REPLACE FUNCTION public.get_next_category_review_deadline()
RETURNS SETOF public.v_brand_matching
LANGUAGE sql STABLE
AS $$
  SELECT * FROM public.v_brand_matching
  WHERE new_item_submission_deadline IS NOT NULL
    AND new_item_submission_deadline >= CURRENT_DATE
  ORDER BY new_item_submission_deadline ASC
  LIMIT 1;
$$;


-- 3h. v_dashboard_summary
CREATE OR REPLACE VIEW public.v_dashboard_summary AS
SELECT
  ( SELECT jsonb_build_object(
      'pipeline_items',     (SELECT COUNT(*) FROM v_task_pipeline_with_assignees WHERE is_completed = false),
      'planned_submissions',(SELECT COUNT(*) FROM planned_submissions),
      'sync_calls',         (SELECT COUNT(*) FROM brand_sync_call_schedule WHERE sync_date = CURRENT_DATE)
    )
  ) AS counts,
  ( SELECT jsonb_build_object(
      'review_name', v.review_name, 'deadline', v.new_item_submission_deadline,
      'managers', v.category_managers, 'brands', v.linked_brands_array, 'count', v.linked_brands_count
    )
    FROM v_brand_matching v
    WHERE v.new_item_submission_deadline IS NOT NULL
      AND v.new_item_submission_deadline >= CURRENT_DATE
    ORDER BY v.new_item_submission_deadline
    LIMIT 1
  ) AS next_review,
  ( SELECT row_to_json(e.*) FROM (
      SELECT id, event_name, event_year, event_dates, event_tags, location, website,
        notes, event_forms, event_dispay_image, event_description, goodnow_participation,
        booth_number, accommodations, event_display_name, internal_event_planning_forms,
        start_date, end_date, attending_brands, attending_team
      FROM events_detailed_view WHERE start_date >= CURRENT_DATE ORDER BY start_date LIMIT 1
    ) e
  ) AS next_event,
  ( SELECT row_to_json(a.*) FROM (
      SELECT id, created_at, announcement, image, audience, archive,
        announcement_tags, announcement_date, announcement_title, publish
      FROM company_announcements
      WHERE announcement_date >= CURRENT_DATE AND publish IS TRUE AND archive IS NOT TRUE
      ORDER BY announcement_date LIMIT 1
    ) a
  ) AS next_announcement,
  ( SELECT jsonb_build_object(
      'submission_id', ps.id, 'planned_date', ps.planned_submission_date,
      'submission_status', ps.submission_status, 'review_name', mcrd.display_name,
      'brand_name', b.brand, 'brand_logo', b.brand_logo, 'deal_name', at.activity_name
    )
    FROM planned_submissions ps
    LEFT JOIN master_category_review_data mcrd ON ps.category_review = mcrd.id
    LEFT JOIN activity_tracker            at   ON ps.deal_id         = at.id
    LEFT JOIN brands                      b    ON at.brand           = b.id
    WHERE ps.planned_submission_date >= CURRENT_DATE
      AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
    ORDER BY ps.planned_submission_date LIMIT 1
  ) AS next_planned_submission;


-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 4: Update ref_migration_tracker
-- ─────────────────────────────────────────────────────────────────────────────

UPDATE public.ref_migration_tracker
SET
  status               = 'done',
  after_junction_table = CASE source_column
    WHEN 'status'          THEN 'jt_ref_brand_status'
    WHEN 'services'        THEN 'jt_ref_active_services'
    WHEN 'coverage'        THEN 'jt_ref_coverage'
    WHEN 'attention_flags' THEN 'jt_ref_brand_attention_flag'
  END,
  views_updated        = true,
  validation_passed    = true,
  executed_at          = NOW(),
  updated_at           = NOW(),
  notes                = COALESCE(notes || ' | ', '') || 'Enum col renamed to _deprecated. Views rewritten to join JTs. Migration: brands_jt_ref_migration_views_v3.'
WHERE source_table = 'brands'
  AND source_column IN ('status', 'services', 'coverage', 'attention_flags');

UPDATE public.ref_migration_tracker 
SET
  after_junction_table = CASE source_column
    WHEN 'flag_for_attention'  THEN 'jt_ref_accounts_flag_for_attention'
    WHEN 'industry_tag_column' THEN 'jt_ref_accounts_industry_tags'
    WHEN 'primary_region'      THEN 'jt_ref_coverage'
  END,
  updated_at           = NOW(),
  notes                = COALESCE(notes || ' | ', '') || 'JT confirmed to exist in schema. No column or view changes applied per instruction.'
WHERE source_table = 'accounts'
  AND source_column IN ('flag_for_attention', 'industry_tag_column', 'primary_region');

COMMIT;
;