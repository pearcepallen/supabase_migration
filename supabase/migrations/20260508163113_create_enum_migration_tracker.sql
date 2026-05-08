
CREATE TABLE IF NOT EXISTS public.ref_migration_tracker (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  -- Identity
  priority_rank integer NOT NULL,
  source_table text NOT NULL,
  source_column text NOT NULL,
  enum_type_name text NOT NULL,
  migration_pattern text NOT NULL CHECK (migration_pattern IN ('single_fk', 'junction_table')),

  -- Before state
  before_data_type text NOT NULL DEFAULT 'USER-DEFINED',
  before_udt_name text NOT NULL,
  before_column_default text,
  before_is_nullable text NOT NULL DEFAULT 'YES',
  before_enum_values text[],

  -- After state (filled in post-migration)
  after_data_type text,
  after_ref_table text,
  after_junction_table text,
  after_fk_constraint text,
  after_index_name text,

  -- Ref table
  ref_table_name text NOT NULL,
  ref_table_existed_before boolean NOT NULL DEFAULT false,
  ref_table_seeded boolean NOT NULL DEFAULT false,
  ref_row_count integer,

  -- Views & dependencies
  views_affected text[],
  views_updated boolean NOT NULL DEFAULT false,
  functions_affected text[],
  triggers_affected text[],
  dependencies_notes text,

  -- Execution
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'done', 'blocked', 'skipped')),
  migration_mode text CHECK (migration_mode IN ('safe', 'destructive')),
  executed_at timestamptz,
  executed_by text,
  sql_applied text,

  -- Validation
  validation_passed boolean,
  null_count_before integer,
  null_count_after integer,
  row_count_before integer,
  row_count_after integer,

  -- Notes
  notes text,
  blocking_reason text,
  skip_reason text
);

COMMENT ON TABLE public.ref_migration_tracker IS 'Tracks enum → ref table migration progress for all columns in the GoodNow CPG / HarvestHub schema.';

CREATE INDEX idx_ref_migration_tracker_status ON public.ref_migration_tracker (status);
CREATE INDEX idx_ref_migration_tracker_priority ON public.ref_migration_tracker (priority_rank);
CREATE INDEX idx_ref_migration_tracker_source ON public.ref_migration_tracker (source_table, source_column);

CREATE OR REPLACE FUNCTION public.ref_migration_tracker_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;

CREATE TRIGGER trg_ref_migration_tracker_updated_at
BEFORE UPDATE ON public.ref_migration_tracker
FOR EACH ROW EXECUTE FUNCTION public.ref_migration_tracker_updated_at();
;