
BEGIN;

CREATE TABLE public.ref_activity_type_enum (
  created_at  timestamptz NOT NULL DEFAULT now(),
  name        text,
  color       text,
  uuid        uuid        NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT  ref_activity_type_enum_pkey PRIMARY KEY (uuid)
);

INSERT INTO public.ref_activity_type_enum (name) VALUES
  ('GNF Deal'),
  ('SOS Program'),
  ('SOS Only Program'),
  ('Placeholder'),
  ('---');

COMMIT;
;