BEGIN;

-- ════════════════════════════════════════════════════════════════
-- 1. v_brand_promo_requests_with_skus
-- Drop and recreate to clear pg_depend link to promo_submissinon_status enum
-- ════════════════════════════════════════════════════════════════

DROP VIEW IF EXISTS public.v_brand_promo_requests_with_skus;

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

-- ════════════════════════════════════════════════════════════════
-- 2. get_task_stats()
-- Return type was kanban_status_enum — task_pipeline.status is now uuid
-- ════════════════════════════════════════════════════════════════

DROP FUNCTION IF EXISTS public.get_task_stats();

CREATE FUNCTION public.get_task_stats()
  RETURNS TABLE(status uuid, task_count bigint, overdue_count bigint)
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    tp.status,
    COUNT(*)                                             AS task_count,
    COUNT(*) FILTER (WHERE tp.due_date < CURRENT_DATE)  AS overdue_count
  FROM task_pipeline tp
  WHERE tp.is_completed = false
  GROUP BY tp.status;
END;
$$;

COMMIT;
