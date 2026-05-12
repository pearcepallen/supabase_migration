
BEGIN;

CREATE TABLE public.ref_demo_request_type_enum (
  created_at  timestamptz NOT NULL DEFAULT now(),
  name        text,
  color       text,
  uuid        uuid        NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT  ref_demo_request_type_enum_pkey PRIMARY KEY (uuid)
);

INSERT INTO public.ref_demo_request_type_enum (name) VALUES
  ('single_store'),
  ('premier_15_stores'),
  ('premier_plus_30_stores');

COMMIT;
;