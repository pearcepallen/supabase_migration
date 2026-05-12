
BEGIN;

CREATE TABLE public.ref_kanban_status_enum (
  created_at  timestamptz NOT NULL DEFAULT now(),
  name        text,
  color       text,
  uuid        uuid        NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT  ref_kanban_status_enum_pkey PRIMARY KEY (uuid)
);

INSERT INTO public.ref_kanban_status_enum (name) VALUES
  ('this_week_overdue'),
  ('next_two_weeks'),
  ('this_month'),
  ('to_watch'),
  ('sos_follow_up');

CREATE TABLE public.ref_source_type_enum (
  created_at  timestamptz NOT NULL DEFAULT now(),
  name        text,
  color       text,
  uuid        uuid        NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT  ref_source_type_enum_pkey PRIMARY KEY (uuid)
);

INSERT INTO public.ref_source_type_enum (name) VALUES
  ('gnf_deal_script'),
  ('sos_deal_script'),
  ('category_review_auto'),
  ('manual'),
  ('auto');

COMMIT;
;