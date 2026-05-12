
-- ── SEED ref tables ───────────────────────────────────────────────────────────

INSERT INTO public.ref_hh_user_role_enum (name) VALUES ('user'), ('admin')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_hh_billing_terms_enum (name) VALUES
  ('monthly'), ('yearly'), ('hh_sponsored_license')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_hh_payment_status_enum (name) VALUES
  ('succeeded'), ('failed')
ON CONFLICT DO NOTHING;

-- ── DROP function (returns SETOF view) ────────────────────────────────────────

DROP FUNCTION IF EXISTS public.get_harvesthub_customers();

-- ── DROP dependent views (column-registered: datagrid + dashboard_stats) ──────

DROP VIEW IF EXISTS public.v_harvesthub_customer_datagrid;
DROP VIEW IF EXISTS public.v_harvesthub_dashboard_stats;

-- ── hh_customers.role ─────────────────────────────────────────────────────────

ALTER TABLE public.hh_customers ADD COLUMN role__new uuid;

UPDATE public.hh_customers t
SET role__new = r.uuid
FROM public.ref_hh_user_role_enum r
WHERE t.role::text = r.name;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.hh_customers
    WHERE role__new IS NULL AND role IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped rows in hh_customers.role — aborting.';
  END IF;
END $$;

ALTER TABLE public.hh_customers DROP COLUMN role;
ALTER TABLE public.hh_customers RENAME COLUMN role__new TO role;

ALTER TABLE public.hh_customers
  ADD CONSTRAINT fk_hh_customers_role
    FOREIGN KEY (role) REFERENCES public.ref_hh_user_role_enum(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_hh_customers_role ON public.hh_customers (role);

-- ── hh_customers.billing_terms ────────────────────────────────────────────────

ALTER TABLE public.hh_customers ADD COLUMN billing_terms__new uuid;

UPDATE public.hh_customers t
SET billing_terms__new = r.uuid
FROM public.ref_hh_billing_terms_enum r
WHERE t.billing_terms::text = r.name;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.hh_customers
    WHERE billing_terms__new IS NULL AND billing_terms IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped rows in hh_customers.billing_terms — aborting.';
  END IF;
END $$;

ALTER TABLE public.hh_customers DROP COLUMN billing_terms;
ALTER TABLE public.hh_customers RENAME COLUMN billing_terms__new TO billing_terms;

ALTER TABLE public.hh_customers
  ADD CONSTRAINT fk_hh_customers_billing_terms
    FOREIGN KEY (billing_terms) REFERENCES public.ref_hh_billing_terms_enum(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_hh_customers_billing_terms ON public.hh_customers (billing_terms);

-- ── hh_customers.payment_status ───────────────────────────────────────────────

ALTER TABLE public.hh_customers ADD COLUMN payment_status__new uuid;

UPDATE public.hh_customers t
SET payment_status__new = r.uuid
FROM public.ref_hh_payment_status_enum r
WHERE t.payment_status::text = r.name;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.hh_customers
    WHERE payment_status__new IS NULL AND payment_status IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped rows in hh_customers.payment_status — aborting.';
  END IF;
END $$;

ALTER TABLE public.hh_customers DROP COLUMN payment_status;
ALTER TABLE public.hh_customers RENAME COLUMN payment_status__new TO payment_status;

ALTER TABLE public.hh_customers
  ADD CONSTRAINT fk_hh_customers_payment_status
    FOREIGN KEY (payment_status) REFERENCES public.ref_hh_payment_status_enum(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_hh_customers_payment_status ON public.hh_customers (payment_status);

-- ── RECREATE v_harvesthub_customer_datagrid ───────────────────────────────────
-- role/billing_terms/payment_status now joined from ref tables → text output

CREATE OR REPLACE VIEW public.v_harvesthub_customer_datagrid AS
SELECT
  c.id,
  c.name,
  c.company,
  c.email,
  c.phone,
  c.status,
  r_role.name           AS role,
  c.rate,
  c.promo_code,
  c.promo_description,
  r_billing.name        AS billing_terms,
  r_payment.name        AS payment_status,
  c.payment_date,
  c.cr_assigned,
  c.discounted_rate,
  c.total_amount_invoiced,
  c.startup_cpg_amount_owed,
  c.created_at,
  ( SELECT jsonb_agg(jt.category_review_id)
    FROM public.jt_hh_customers_category_reviews jt
    WHERE jt.customer_id = c.id ) AS category_reviews,
  c.promo_code_id,
  c.cancellation_reason,
  c.customer_notes,
  c.profile_photo,
  c.updated_at,
  c.invoiced_amount,
  c.startup_cpg_paid,
  c.startup_cpg_paid_date,
  jsonb_build_object('id', p.id, 'name', p.name, 'profile_photo', p.profile_photo) AS last_modified_by
FROM public.hh_customers c
LEFT JOIN public.ref_hh_user_role_enum      r_role    ON r_role.uuid    = c.role
LEFT JOIN public.ref_hh_billing_terms_enum  r_billing ON r_billing.uuid = c.billing_terms
LEFT JOIN public.ref_hh_payment_status_enum r_payment ON r_payment.uuid = c.payment_status
LEFT JOIN public.profiles p ON c.modified_by = p.id;

-- ── RECREATE v_harvesthub_dashboard_stats ─────────────────────────────────────
-- billing_terms comparisons rewritten: join ref_hh_billing_terms_enum, filter on r.name
-- status comparisons kept as-is (hh_customer_status_enum not migrated in this batch)

CREATE OR REPLACE VIEW public.v_harvesthub_dashboard_stats AS
WITH current_metrics AS (
  SELECT
    count(*) FILTER (WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum) AS active_count,
    count(*) FILTER (WHERE hh_customers.status = 'Cancelled'::hh_customer_status_enum)       AS churn_count,
    count(*) FILTER (WHERE hh_customers.status = 'Signed Up'::hh_customer_status_enum)       AS pending_count,
    sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'monthly'
        )
    ) AS current_mrr,
    COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'monthly'
        )
    ), 0::numeric) * 12::numeric
    + COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'yearly'
        )
    ), 0::numeric) AS current_arr
  FROM public.hh_customers
),
previous_metrics AS (
  SELECT
    count(*) FILTER (WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum) AS active_count,
    count(*) FILTER (WHERE hh_customers.status = 'Cancelled'::hh_customer_status_enum)       AS churn_count,
    count(*) FILTER (WHERE hh_customers.status = 'Signed Up'::hh_customer_status_enum)       AS pending_count,
    sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'monthly'
        )
    ) AS mrr,
    COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'monthly'
        )
    ), 0::numeric) * 12::numeric
    + COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (
      WHERE hh_customers.status = 'Active Customer'::hh_customer_status_enum
        AND EXISTS (
          SELECT 1 FROM public.ref_hh_billing_terms_enum r
          WHERE r.uuid = hh_customers.billing_terms AND r.name = 'yearly'
        )
    ), 0::numeric) AS arr
  FROM public.hh_customers
  WHERE hh_customers.created_at <= (now() - '30 days'::interval)
),
contribution_stats AS (
  SELECT
    count(*) FILTER (WHERE hh_contributions.created_at >= date_trunc('month', now()))                                                                             AS current_month_count,
    count(*) FILTER (WHERE hh_contributions.created_at >= date_trunc('month', now() - '1 mon'::interval)
                       AND hh_contributions.created_at <  date_trunc('month', now()))                                                                             AS last_month_count
  FROM public.hh_contributions
)
SELECT
  c.active_count                                        AS active_customers,
  c.churn_count                                         AS churned_customers,
  c.pending_count                                       AS pending_conversions,
  COALESCE(c.current_mrr, 0::numeric)                   AS mrr,
  COALESCE(c.current_arr, 0::numeric)                   AS arr,
  con.current_month_count                               AS this_months_contributions,
  c.active_count  - p.active_count                      AS active_change,
  c.churn_count   - p.churn_count                       AS churn_change,
  c.pending_count - p.pending_count                     AS pending_conversion_change,
  COALESCE(c.current_mrr, 0::numeric) - COALESCE(p.mrr, 0::numeric) AS mrr_change,
  COALESCE(c.current_arr, 0::numeric) - COALESCE(p.arr, 0::numeric) AS arr_change,
  con.current_month_count - con.last_month_count        AS contributions_change
FROM current_metrics c, previous_metrics p, contribution_stats con;

-- ── RECREATE get_harvesthub_customers (verbatim — body unchanged) ─────────────

CREATE OR REPLACE FUNCTION public.get_harvesthub_customers()
RETURNS SETOF public.v_harvesthub_customer_datagrid
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT * FROM public.v_harvesthub_customer_datagrid;
$$;
;