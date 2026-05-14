BEGIN;

-- ════════════════════════════════════════════════════════════════
-- RANK 62 — team_member_guide.status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_employee_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_employee_status (uuid, name) VALUES
  ('d4e5f6a7-0004-0004-0004-000000000001', 'Activating'),
  ('d4e5f6a7-0004-0004-0004-000000000002', 'Active'),
  ('d4e5f6a7-0004-0004-0004-000000000003', 'Former Employee');

-- ── Drop dependents ────────────────────────────────────────────
DROP VIEW IF EXISTS public.v_my_internal_profile;
DROP TRIGGER IF EXISTS on_employee_status_change ON public.team_member_guide;

-- ── Migrate column ─────────────────────────────────────────────
ALTER TABLE public.team_member_guide ADD COLUMN status__new uuid;
UPDATE public.team_member_guide t SET status__new = r.uuid
FROM public.ref_employee_status r WHERE r.name = t.status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.team_member_guide WHERE status IS NOT NULL AND status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 62 guard: unmapped non-null status in team_member_guide'; END IF;
END $$;
ALTER TABLE public.team_member_guide DROP COLUMN status;
ALTER TABLE public.team_member_guide RENAME COLUMN status__new TO status;
ALTER TABLE public.team_member_guide
  ADD CONSTRAINT fk_team_member_guide_status
  FOREIGN KEY (status) REFERENCES public.ref_employee_status(uuid);
CREATE INDEX idx_team_member_guide_status ON public.team_member_guide(status);

-- ── Rewrite handle_employee_status_change() ───────────────────
-- 'd4e5f6a7-0004-0004-0004-000000000002' = 'Active'
CREATE OR REPLACE FUNCTION public.handle_employee_status_change()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.status != 'd4e5f6a7-0004-0004-0004-000000000002'::uuid
     AND OLD.status = 'd4e5f6a7-0004-0004-0004-000000000002'::uuid THEN

    DELETE FROM public.users_roles
    WHERE user_id IN (
      SELECT id FROM auth.users WHERE team_member_id = NEW.uuid
    );

    INSERT INTO public.audit_log (action, team_member_id, timestamp)
    VALUES ('employee_deactivated', NEW.uuid, NOW());
  END IF;
  RETURN NEW;
END;
$$;

-- ── Recreate trigger ───────────────────────────────────────────
CREATE TRIGGER on_employee_status_change
  AFTER UPDATE OF status ON public.team_member_guide
  FOR EACH ROW EXECUTE FUNCTION public.handle_employee_status_change();

-- ── Rewrite is_active_employee() ──────────────────────────────
-- 'd4e5f6a7-0004-0004-0004-000000000002' = 'Active'
CREATE OR REPLACE FUNCTION public.is_active_employee(user_id uuid)
  RETURNS boolean
  LANGUAGE plpgsql
  SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM auth.users u
    JOIN public.team_member_guide tmg ON u.team_member_id = tmg.uuid
    WHERE u.id = user_id
      AND tmg.status = 'd4e5f6a7-0004-0004-0004-000000000002'::uuid
  );
END;
$$;

-- ── Recreate v_my_internal_profile ────────────────────────────
CREATE VIEW public.v_my_internal_profile AS
SELECT
  p.id, p.name, p.created_at, p.brand_id, p.department, p.user_type, p.profile_photo,
  tmg.status,
  tmg.title, tmg.address, tmg.phone_number,
  tmg.department AS public_department,
  tmg.send_samples, tmg.food_handlers_card, tmg.calls_counted_by_team_member,
  tmg.counter, tmg.email, tmg.key_support AS key_accounts,
  tmg.regional_coverage, tmg.time_zone, tmg.country_of_origin, tmg.language_spoken
FROM profiles p
LEFT JOIN team_member_guide tmg ON p.id = tmg.uuid
WHERE p.id = auth.uid();

-- ── Tracker ────────────────────────────────────────────────────
UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_employee_status created. is_active_employee() + handle_employee_status_change() rewritten. v_my_internal_profile recreated.'
WHERE priority_rank = 62;

COMMIT;
