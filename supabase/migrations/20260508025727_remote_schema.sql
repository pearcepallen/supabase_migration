set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public."(deprecated) handle_account_distributor_sync"()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
  IF (TG_OP = 'DELETE') THEN
    -- When an account is deleted, remove its distributor entry.
    DELETE FROM ref_distributor
    WHERE account_id = OLD.uuid;

  ELSIF (TG_OP = 'UPDATE') THEN
    IF (NEW.account_type IN ('Distributor', 'Distributor - HQ')) THEN
      -- Insert or update id and distributor
      INSERT INTO ref_distributor (account_id, distributor)
      VALUES (NEW.uuid, NEW.account)
      ON CONFLICT (account_id)
      DO UPDATE SET
        distributor = EXCLUDED.distributor;
    ELSE
      -- If the Account_Type is changed to a non-distributor type, remove any distributor entry
      DELETE FROM ref_distributor
      WHERE account_id = NEW.uuid;
    END IF;

  ELSIF (TG_OP = 'INSERT') THEN
    IF (NEW.account_type IN ('Distributor', 'Distributor - HQ')) THEN
      -- Insert or update id and distributor
      INSERT INTO ref_distributor (account_id, distributor)
      VALUES (NEW.uuid, NEW.account)
      ON CONFLICT (account_id)
      DO UPDATE SET
        distributor = EXCLUDED.distributor;
    END IF;
  END IF;

  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.activity_tracker_set_last_updated()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.last_updated = now();
  -- Automatically capture the Supabase user making the change
  NEW.last_modified_by = auth.uid(); 
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_customer_to_category(customer_uuid uuid, category_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO jt_hh_customers_master_categories (customer_id, master_category_id)
    VALUES (customer_uuid, category_uuid)
    ON CONFLICT (customer_id, master_category_id) DO NOTHING;
    
    RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.auto_complete_demo()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
  -- Auto-complete when core completion metrics are provided
  IF NEW.demo_status IN ('Store Confirmed', 'Inventory Confirmed') 
     AND NEW.demo_feedback IS NOT NULL 
     AND NEW.demo_hours > 0 
     AND NEW.store_busy_rating IS NOT NULL 
     AND NEW.units_before IS NOT NULL 
     AND NEW.units_after IS NOT NULL THEN
    NEW.demo_status = 'Completed';
  END IF;
  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.calculate_onboarding_completion()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Count completed tasks
    NEW.total_tasks_completed := (
        CASE WHEN NEW.sell_sheets_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.pitch_deck_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.product_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.lifestyle_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.upc_barcode_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.w9_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.spec_sheet_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.distribution_info_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.retail_info_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.certifications_completed THEN 1 ELSE 0 END
    );
    
    -- Calculate percentage
    NEW.overall_completion_percentage := (NEW.total_tasks_completed::DECIMAL / NEW.total_tasks::DECIMAL) * 100;
    
    -- Set completion date if 100% complete
    IF NEW.overall_completion_percentage = 100 AND OLD.overall_completion_percentage < 100 THEN
        NEW.onboarding_completed_date := NOW();
    ELSIF NEW.overall_completion_percentage < 100 THEN
        NEW.onboarding_completed_date := NULL;
    END IF;
    
    -- Update timestamp
    NEW.updated_at := NOW();
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_total_hours()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.total_hours = COALESCE(NEW.demo_hours, 0) + 
                   COALESCE(NEW.training_hours, 0) + 
                   COALESCE(NEW.merchandising_hours, 0) + 
                   COALESCE(NEW.other_hours, 0);
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cascade_account_name_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE contacts
  SET full_name_and_account = CONCAT(
    first_name, ' ', last_name, ' - ',
    NEW.account
  )
  WHERE account_uuid = NEW.uuid;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.complete_task(task_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE task_pipeline 
  SET is_completed = true,
      completed_at = NOW()
  WHERE id = task_id;
  
  RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_default_brand_folders(p_brand_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    -- Variable to hold the fetched brand name
    v_brand_name text;
    
    -- The master "Brands" folder ID
    v_master_brands_folder_id uuid := '6f709eb8-ab08-4977-a767-8a2ce324aff6';
    
    v_distribution_folder_id uuid;
    v_images_folder_id uuid;
BEGIN
    -- 0. Fetch the brand name from the brands table
    SELECT brand INTO v_brand_name 
    FROM public.brands 
    WHERE id = p_brand_id;

    -- Safety check: stop the function if the brand doesn't exist
    IF v_brand_name IS NULL THEN
        RAISE EXCEPTION 'Brand with ID % not found. Cannot create folders.', p_brand_id;
    END IF;

    -- 1. Create the Brand Folder nested under the master "Brands" folder
    INSERT INTO public.folders (id, name, parent_id, brand_id)
    VALUES (p_brand_id, v_brand_name, v_master_brands_folder_id, p_brand_id);

    -- 2. Create standard main folders without subfolders (using text tags in tag_id)
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id) VALUES 
        ('Vendor Contracts', p_brand_id, p_brand_id, 'Contracts'),
        ('Brand Planning', p_brand_id, p_brand_id, 'Planning'),
        ('Certifications', p_brand_id, p_brand_id, 'Certifications'),
        ('Retail', p_brand_id, p_brand_id, 'Retail'),
        ('Promotional Planning', p_brand_id, p_brand_id, 'Promos'),
        ('Reports + Sales Data', p_brand_id, p_brand_id, 'Reports'),
        ('Archive', p_brand_id, p_brand_id, 'Archive'),
        ('W9', p_brand_id, p_brand_id, 'W9');

    -- 3. Create Distribution folder and its subfolder
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id)
    VALUES ('Distribution', p_brand_id, p_brand_id, 'Distribution')
    RETURNING id INTO v_distribution_folder_id;
    
    INSERT INTO public.folders (name, parent_id, brand_id)
    VALUES ('TO Forms', v_distribution_folder_id, p_brand_id);

    -- 4. Create Images folder and its subfolders
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id)
    VALUES ('Images', p_brand_id, p_brand_id, 'Images')
    RETURNING id INTO v_images_folder_id;

    INSERT INTO public.folders (name, parent_id, brand_id) VALUES 
        ('Lifestyle Images', v_images_folder_id, p_brand_id),
        ('UPC Barcode Images', v_images_folder_id, p_brand_id),
        ('Product Images', v_images_folder_id, p_brand_id),
        ('Product Labels', v_images_folder_id, p_brand_id);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_default_brand_folders(p_brand_id uuid, p_brand_name text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    -- The master "Brands" folder ID
    v_master_brands_folder_id uuid := '6f709eb8-ab08-4977-a767-8a2ce324aff6';
    
    v_distribution_folder_id uuid;
    v_images_folder_id uuid;
BEGIN
    -- 1. Create the Brand Folder nested under the master "Brands" folder
    INSERT INTO public.folders (id, name, parent_id, brand_id)
    VALUES (p_brand_id, p_brand_name, v_master_brands_folder_id, p_brand_id);

    -- 2. Create standard main folders without subfolders (using text tags)
    INSERT INTO public.folders (name, parent_id, brand_id, tag) VALUES 
        ('Vendor Contracts', p_brand_id, p_brand_id, 'Contracts'),
        ('Brand Planning', p_brand_id, p_brand_id, 'Planning'),
        ('Certifications', p_brand_id, p_brand_id, 'Certifications'),
        ('Retail', p_brand_id, p_brand_id, 'Retail'),
        ('Promotional Planning', p_brand_id, p_brand_id, 'Promos'),
        ('Reports + Sales Data', p_brand_id, p_brand_id, 'Reports'),
        ('Archive', p_brand_id, p_brand_id, 'Archive'),
        ('W9', p_brand_id, p_brand_id, 'W9');

    -- 3. Create Distribution folder and its subfolder
    INSERT INTO public.folders (name, parent_id, brand_id, tag)
    VALUES ('Distribution', p_brand_id, p_brand_id, 'Distribution')
    RETURNING id INTO v_distribution_folder_id;
    
    INSERT INTO public.folders (name, parent_id, brand_id)
    VALUES ('TO Forms', v_distribution_folder_id, p_brand_id);

    -- 4. Create Images folder and its subfolders
    INSERT INTO public.folders (name, parent_id, brand_id, tag)
    VALUES ('Images', p_brand_id, p_brand_id, 'Images')
    RETURNING id INTO v_images_folder_id;

    INSERT INTO public.folders (name, parent_id, brand_id) VALUES 
        ('Lifestyle Images', v_images_folder_id, p_brand_id),
        ('UPC Barcode Images', v_images_folder_id, p_brand_id),
        ('Product Images', v_images_folder_id, p_brand_id),
        ('Product Labels', v_images_folder_id, p_brand_id);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_mention_notifications()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$declare
  mention text;
  clean_name text;
  mentioned_uuid uuid;
  mentions text[];
begin
  -- 1. Encontrar todas las menciones tipo @Nombre
  mentions := regexp_matches(new.activity_notes, '@([A-Za-z0-9_ ]+)', 'g');

  -- 2. Recorrer todas las menciones encontradas
  foreach mention in array mentions loop
    
    -- Quitar el '@'
    clean_name := trim(both '@' from mention);

    -- Buscar el usuario en team_member_guide por nombre EXACTO
    select id 
    into mentioned_uuid
    from team_member_guide
    where name = clean_name
    limit 1;

    -- Si encontramos el usuario, crear notificación
    if mentioned_uuid is not null then
      insert into notifications (recipient_id, type, data)
      values (
        mentioned_uuid,
        'mention',
        jsonb_build_object(
          'mentioned_name', clean_name,
          'activity_name', new.activity_name,
          'message', clean_name || ' was mentioned in activity "' || new.activity_name || '"'
        )
      );
    end if;

  end loop;

  return new;
end;$function$
;

CREATE OR REPLACE FUNCTION public.create_rls_policies(table_names text[], role_dept_codes text[], operation text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    tab text;
    policy_sql text;
    policy_name text;
    check_clause text;
BEGIN
    -- This is the core security condition. It checks if a user belongs to any of the specified roles.
    -- We use '= ANY($1)' which is an efficient way to check for existence in an array parameter.
    check_clause := format(
        'EXISTS (SELECT 1 FROM jt_user_role_dept urd JOIN team_member_dept tmd ON urd.dept_id = tmd.id WHERE urd.user_id = (select auth.uid()) AND tmd.dept_code = ANY(%L))',
        role_dept_codes
    );

    -- Loop through each table provided in the input array
    FOREACH tab IN ARRAY table_names
    LOOP
        -- Create a descriptive and unique policy name, e.g., 'task_pipeline_select_policy'
        policy_name := format('%s_%s_policy', tab, lower(operation));

        -- Drop the old policy if it exists to ensure we can re-run this script safely
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I;', policy_name, tab);

        -- Build the appropriate CREATE POLICY statement based on the operation
        IF operation = 'SELECT' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR SELECT USING (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'INSERT' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR INSERT WITH CHECK (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'UPDATE' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR UPDATE USING (%s) WITH CHECK (%s);', policy_name, tab, check_clause, check_clause);
        ELSIF operation = 'DELETE' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR DELETE USING (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'ALL' THEN
            -- The 'ALL' command applies USING to SELECT, UPDATE, DELETE and WITH CHECK to INSERT, UPDATE.
            policy_sql := format('CREATE POLICY %I ON public.%I FOR ALL USING (%s) WITH CHECK (%s);', policy_name, tab, check_clause, check_clause);
        ELSE
            -- Raise an error for an invalid operation to prevent mistakes
            RAISE EXCEPTION 'Invalid operation specified: %. Must be one of SELECT, INSERT, UPDATE, DELETE, ALL', operation;
        END IF;
        -- Execute the dynamically constructed SQL statement
        EXECUTE policy_sql;
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_task_on_deal_stage_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  new_task_id UUID; -- A variable to hold the ID of a newly created task.
  deal_owner_exists BOOLEAN; -- Added for debugging
BEGIN
   -- ================== DEBUGGING BLOCK ==================
  SELECT EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) INTO deal_owner_exists;
  RAISE NOTICE '--- DEBUG TRIGGER ---';
  RAISE NOTICE 'TG_OP: %', TG_OP;
  RAISE NOTICE 'Activity ID: %', NEW.id;
  RAISE NOTICE '1. Activity Type: %', NEW.activity_type;
  RAISE NOTICE '2. Deal Owner Exists?: %', deal_owner_exists;
  RAISE NOTICE '3. Assign for Follow Up: %', NEW.assign_for_follow_up;
  RAISE NOTICE '---------------------';
  -- =======================================================

  -- This block handles when an EXISTING activity_tracker record is UPDATED.
  IF TG_OP = 'UPDATE' AND NEW.assign_for_follow_up <> OLD.assign_for_follow_up THEN    
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      -- First, update the status of any existing tasks.
      UPDATE public.task_pipeline
      SET status = 'sos_follow_up'::public.kanban_status_enum,
          updated_at = now()
      WHERE activity_tracker_id = NEW.id;
      -- NEW LOGIC: Also ensure the assignment exists for any updated tasks.
      -- This finds all tasks for the deal and creates the assignment if it doesn't already exist.
      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      SELECT id, NEW.assign_for_follow_up
      FROM public.task_pipeline
      WHERE activity_tracker_id = NEW.id
      ON CONFLICT (task_id, team_member_uuid) DO NOTHING;

      -- If no tasks were found to update, create a new one AND assign it.
      IF NOT FOUND THEN
        -- Step 1: Create the task and capture its ID.
        INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (NEW.activity_name, 'deal_activity', 'sos_follow_up'::public.kanban_status_enum, NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
        RETURNING id INTO new_task_id;

        -- Step 2: Use the captured ID to create the assignment.
        INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
        VALUES (new_task_id, NEW.assign_for_follow_up);
      END IF;
    ELSE
      -- Original deal stage logic (on update) is unchanged...
      UPDATE public.task_pipeline
      SET status = CASE
                     WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
                     WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
                     WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
                     ELSE status
                   END,
          updated_at = now()
      WHERE activity_tracker_id = NEW.id;

      IF NOT FOUND AND NEW.deal_stage IN ('Presenting', 'Approved: in Setup', 'Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up', 'Target') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
        INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (
          NEW.activity_name, 'deal_activity',
          CASE
            WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
            WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
            WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
          END,
          NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
        );
      END IF;
    END IF;

  -- This block handles when a NEW activity_tracker record is INSERTED.
  ELSIF TG_OP = 'INSERT' THEN
    -- SOS Check (on insert)
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      -- Step 1: Create the task and capture its ID.
      INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (NEW.activity_name, 'deal_activity', 'sos_follow_up'::public.kanban_status_enum, NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
      RETURNING id INTO new_task_id;

      -- Step 2: Use the captured ID to create the assignment.
      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      VALUES (new_task_id, NEW.assign_for_follow_up);
    END IF;

    -- Deal Stage Check (on insert) is unchanged...
    IF NEW.deal_stage IN ('Presenting', 'Approved: in Setup', 'Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up', 'Target') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
      INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (
        NEW.activity_name, 'deal_activity',
        CASE
          WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
          WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
          WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
        END,
        NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_tasks_from_activity_tracker()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
  rec RECORD;
  task_count INTEGER := 0;
  v_status kanban_status_enum;
  v_source_type source_type_enum;
  v_task_title TEXT;
BEGIN
  -- Create tasks for activities marked for task tracker
  FOR rec IN 
    SELECT 
      at.*,
      a.account as account_name, 
      b.brand as brand_name
    FROM activity_tracker at
    LEFT JOIN accounts a ON at.account = a.uuid  
    LEFT JOIN brands b ON at.brand = b.id
    WHERE at.send_to_task_tracker = true
    AND NOT EXISTS (
      SELECT 1 FROM task_pipeline tp WHERE tp.activity_tracker_id = at.id
    )
  LOOP
    -- Determine status and source
    v_status := determine_task_status(rec.id);
    v_source_type := CASE 
      WHEN rec.activity_type::text IN ('SOS Program', 'SOS Only Program') 
      THEN 'sos_deal_script'::source_type_enum
      ELSE 'gnf_deal_script'::source_type_enum
    END;
    
    -- Create descriptive task title
    v_task_title := COALESCE(
      rec.account_name || ' - ' || rec.brand_name,
      rec.account_name || ' Deal Activity',
      rec.brand_name || ' Deal Activity',
      'Deal Activity'
    );
    
    -- Create task
    INSERT INTO task_pipeline (
      task_title,
      notes,
      task_type,
      status,
      activity_tracker_id,
      brand_id,
      account_id,
      assigned_to,
      is_automated,
      source_type
    ) VALUES (
      v_task_title,
      rec.activity_notes,
      'deal_activity',
      v_status,
      rec.id,
      rec.brand,
      rec.account,
      rec.assign_for_follow_up,
      true,
      v_source_type
    );
    
    task_count := task_count + 1;
  END LOOP;
  
  RETURN task_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_tasks_from_category_reviews()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
  rec RECORD;
  brand_rec RECORD;
  task_count INTEGER := 0;
  v_status kanban_status_enum;
  v_task_title TEXT;
BEGIN
  -- Create tasks for category reviews with upcoming deadlines and linked brands
  FOR rec IN 
    SELECT 
      cr.*,
      a.account as account_name
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    WHERE cr.new_item_submission_deadline IS NOT NULL
    AND cr.new_item_submission_deadline >= CURRENT_DATE
    AND cr.new_item_submission_deadline <= CURRENT_DATE + INTERVAL '60 days'
    AND NOT EXISTS (
      SELECT 1 FROM task_pipeline tp WHERE tp.category_review_id = cr.id
    )
  LOOP
    -- Find linked brands for this category review
    FOR brand_rec IN
      SELECT DISTINCT b.*
      FROM jt_master_category_review_data_brands jt
      JOIN brands b ON jt.brand_id = b.id
      WHERE jt.master_category_review_data_id = rec.id
    LOOP
      -- Determine status based on deadline
      v_status := determine_task_status(NULL, rec.new_item_submission_deadline);
      
      -- Create descriptive task title
      v_task_title := rec.account_name || ' - ' || brand_rec.brand || ' Category Review';
      
      -- Create task for each brand
      INSERT INTO task_pipeline (
        task_title,
        notes,
        task_type,
        status,
        category_review_id,
        brand_id,
        account_id,
        due_date,
        is_automated,
        source_type
      ) VALUES (
        v_task_title,
        'Category review deadline: ' || rec.new_item_submission_deadline::text,
        'category_review',
        v_status,
        rec.id,
        brand_rec.id,
        rec.account,
        rec.new_item_submission_deadline,
        true,
        'category_review_auto'
      );
      
      task_count := task_count + 1;
    END LOOP;
  END LOOP;
  
  RETURN task_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$declare
  claims jsonb;
  v_brand_id uuid;
  v_department text;
  v_user_type text; -- Prefixed with v_ to avoid ambiguity
begin
  -- 1. Fetch data using the table names, but INTO the prefixed variables
  select brand_id, department, user_type 
  into v_brand_id, v_department, v_user_type
  from public.profiles
  where id = (event->>'user_id')::uuid;

  claims := event->'claims';

  -- 2. Set Brand ID
  if v_brand_id is not null then
    claims := jsonb_set(claims, '{app_metadata, brand_id}', to_jsonb(v_brand_id));
  end if;

  -- 3. Set Department
  if v_department is not null then
    claims := jsonb_set(claims, '{app_metadata, department}', to_jsonb(v_department));
  end if;

  -- 4. Set User Type
  if v_user_type is not null then
    claims := jsonb_set(claims, '{app_metadata, user_type}', to_jsonb(v_user_type));
  end if;

  event := jsonb_set(event, '{claims}', claims);
  return event;
end;$function$
;

CREATE OR REPLACE FUNCTION public.determine_task_status(p_activity_tracker_id uuid, p_due_date date)
 RETURNS public.kanban_status_enum
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_deal_stage TEXT;
  v_activity_type TEXT;
BEGIN
  -- Get deal info from activity_tracker if provided
  IF p_activity_tracker_id IS NOT NULL THEN
    SELECT deal_stage::text, activity_type::text 
    INTO v_deal_stage, v_activity_type
    FROM activity_tracker 
    WHERE id = p_activity_tracker_id;
    
    -- SOS Program logic
    IF v_activity_type IN ('SOS Program', 'SOS Only Program') THEN
      RETURN 'sos_follow_up';
    END IF;
    
    -- GNF Deal logic based on deal stage
    CASE v_deal_stage
      WHEN 'Presenting', 'Approved: in Setup' THEN
        RETURN 'this_month';
      WHEN 'Target' THEN  
        RETURN 'to_watch';
      WHEN 'Presenting - Buyer Introduction', 
           'Presenting - Buyer Engagement / Meeting',
           'Presenting - Post Review Follow-Up' THEN
        RETURN 'next_two_weeks';
      ELSE
        RETURN 'this_month';
    END CASE;
  END IF;
  
  -- Date-based logic for manual tasks and category reviews
  IF p_due_date IS NOT NULL THEN
    IF p_due_date < CURRENT_DATE OR 
       (p_due_date >= CURRENT_DATE AND p_due_date <= CURRENT_DATE + INTERVAL '7 days') THEN
      RETURN 'this_week_overdue';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '14 days' THEN
      RETURN 'next_two_weeks';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '30 days' THEN
      RETURN 'this_month';
    ELSE
      RETURN 'to_watch';
    END IF;
  END IF;
  
  -- Default: If the due date is cleared to NULL, send it to the backlog
  RETURN 'to_watch';
END;
$function$
;

CREATE OR REPLACE FUNCTION public.enforce_connect_count()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.deal_stage ILIKE 'Connect%' THEN
    NEW.connect_count := 1;
  ELSE
    NEW.connect_count := 0;
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_account_type_enum()
 RETURNS TABLE(account_type_value text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS account_type_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'account_type_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_activity_type()
 RETURNS TABLE(activity_type_value text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS activity_type_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'activity_type_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_brand_contact_tags()
 RETURNS TABLE(brand_contact_tags_type text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS    brand_contact_tags
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'Brand Contact Tags'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_brand_folder()
 RETURNS TABLE(deal_stage_value text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS folders_enum
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'folders_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_category_review_status()
 RETURNS TABLE(category_review_status text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS category_review_status
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'category_review_status_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_connect_enum()
 RETURNS TABLE(connect_enum text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS 	connect_enum
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'connect_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_deal_stage()
 RETURNS TABLE(deal_stage_value text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS deal_stage_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'deal_stage_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_deals_for_tasks(p_accounts uuid[] DEFAULT '{}'::uuid[], p_brands uuid[] DEFAULT '{}'::uuid[])
 RETURNS TABLE(id uuid, activity_name text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.activity_name
  FROM activity_tracker t
  WHERE 
    -- 1. Deal must belong to the selected Accounts (this check is bypassed if no accounts are chosen)
    (
      p_accounts IS NULL 
      OR array_length(p_accounts, 1) IS NULL 
      OR t.account = ANY(p_accounts)
    )
    AND -- <--- This AND is what forces the strict "Pair" requirement
    -- 2. Deal must belong to the selected Brands (this check is bypassed if no brands are chosen)
    (
      p_brands IS NULL 
      OR array_length(p_brands, 1) IS NULL 
      OR t.brand = ANY(p_brands)
    );
END;$function$
;

CREATE OR REPLACE FUNCTION public.fetch_hh_customer_billing_terms_enum()
 RETURNS TABLE(account_type_value text)
 LANGUAGE sql
AS $function$SELECT
    enumlabel AS hh_billing_terms_value
FROM
    pg_enum
WHERE
    enumtypid = (
        SELECT oid FROM pg_type WHERE typname = 'hh_billing_terms_enum'
    );$function$
;

CREATE OR REPLACE FUNCTION public.fetch_primary_region()
 RETURNS TABLE(primary_region text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS primary_region
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'Region'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_program_status()
 RETURNS TABLE(program_status_type text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS 	program_status_type
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'program_status_type'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_sku_placement_type()
 RETURNS TABLE(placement_type text)
 LANGUAGE sql
AS $function$
    SELECT
        enumlabel AS placement_type
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'placement_type_enum'
        );
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_tasks_for_deal(p_deal_id uuid)
 RETURNS SETOF public.v_task_pipeline_with_assignees
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT *
  FROM v_task_pipeline_with_assignees
  WHERE 
    -- This searches the JSONB array for an object containing the specific deal_id
    linked_deals @> jsonb_build_array(jsonb_build_object('deal_id', p_deal_id));
$function$
;

CREATE OR REPLACE FUNCTION public.fill_full_category()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
BEGIN
  NEW.full_category := NEW.category::TEXT || ' - ' || NEW.subcategory;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.filter_notes_by_brands(brand_names text[])
 RETURNS TABLE(id uuid, brand text)
 LANGUAGE sql
AS $function$select id, brand
  from brands
  where brand = any(brand_names);$function$
;

CREATE OR REPLACE FUNCTION public.format_item_name(description_text text, qty numeric, unit_val public.uom_enum)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
BEGIN
  RETURN COALESCE(description_text, '') || ' - ' || COALESCE(qty::text, '') || ' ' || COALESCE(unit_val::text, '');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_review_data_name(review_data_id uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$DECLARE
    account_name TEXT;
    retail_cat TEXT;  -- Renamed variable
    result_name TEXT;
BEGIN
    -- Get account name and Retailer Category
    SELECT 
        a.account,
        mcrd.retailer_category  -- Select directly from the review data table
    INTO 
        account_name,
        retail_cat
    FROM master_category_review_data mcrd
    JOIN accounts a ON mcrd.account = a.uuid
    -- JOIN master_categories removed (not needed anymore)
    WHERE mcrd.id = review_data_id;
    
    -- Construct the name: Account - Retailer Category
    IF account_name IS NOT NULL AND retail_cat IS NOT NULL THEN
        result_name := account_name || ' - ' || retail_cat;
    ELSIF account_name IS NOT NULL THEN
        result_name := account_name || ' - Unknown Category';
    ELSE
        result_name := 'Unknown Account - Unknown Category';
    END IF;
    
    RETURN result_name;
END;$function$
;

CREATE OR REPLACE FUNCTION public.get_associated_skus(input_deal_id uuid)
 RETURNS TABLE(sku_id uuid, sku_name text, category_list jsonb, placement_status text, distribution_details jsonb)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    target_brand_id UUID;
    target_account_id UUID;
BEGIN
    -- 1. Get the Context
    SELECT brand, account 
    INTO target_brand_id, target_account_id
    FROM public.activity_tracker
    WHERE id = input_deal_id;

    -- 2. Return the Master List
    RETURN QUERY
    SELECT 
        s.id AS sku_id,
        s.unique_item_name AS sku_name,
        
        -- Category Logic
        COALESCE(
            (
                SELECT JSONB_AGG(DISTINCT 
                    COALESCE(mc.full_category, mc.category::text, mc.subcategory, 'Uncategorized')
                )
                FROM public.sku_product_category spc
                JOIN public.master_categories mc ON spc.product_category = mc.id
                WHERE spc.brand_product_sku = s.id
            ),
            '[]'::jsonb
        ) AS category_list,
        
        sp.sku_status::text AS placement_status,
        
        -- UPDATED DISTRIBUTION LOGIC
        COALESCE(
            (
                SELECT JSONB_AGG(
                    JSONB_BUILD_OBJECT(
                        'grid_id', bdg.id,                     -- <--- REQUIRED for Updates
                        'current_status', bdg.distribution_status, -- <--- REQUIRED to see current status
                        'distributor_name', dist_acc.account,
                        'distributor_id', dist_acc.uuid,
                        'warehouse_name', dc_acc.account,
                        'warehouse_id', dc_acc.uuid,
                        'item_code', bdg.item_code
                    )
                )
                FROM public.brand_distribution_grid bdg
                
                -- Use LEFT JOINs so we don't lose the row if the link is missing
                LEFT JOIN public.jt_accounts_distribution jt 
                    ON bdg.distributor_hq = jt.distributor_account_id
                    AND jt.retail_account_id = target_account_id
                
                LEFT JOIN public.accounts dist_acc 
                    ON bdg.distributor_hq = dist_acc.uuid
                    
                LEFT JOIN public.accounts dc_acc 
                    ON bdg.warehouse_dc = dc_acc.uuid
                
                WHERE 
                    bdg.item_name = s.id
                    AND (
                        -- Condition 1: Explicit Link exists in JT
                        jt.id IS NOT NULL 
                        -- Condition 2: The Deal Account IS the Distributor (Direct)
                        OR bdg.distributor_hq = target_account_id
                        -- Condition 3: The Deal Account IS the Warehouse (Direct)
                        OR bdg.warehouse_dc = target_account_id
                    )
            ),
            '[]'::jsonb
        ) AS distribution_details

    FROM 
        public.spec_price_sheet s
        
        LEFT JOIN public.sku_placements sp 
            ON s.id = sp.sku_id 
            AND sp.deal_id = input_deal_id

    WHERE 
        s.brand_id = target_brand_id
        
    GROUP BY 
        s.id, s.unique_item_name, sp.sku_status;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_associated_skus_by_deal_id(p_deal_id uuid)
 RETURNS TABLE(sku_id uuid, sku_description text, sku_item_status text, sku_upc_12_digit text)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT
      sps.id AS sku_id,
      sps.description AS sku_description,
      sps.item_status::TEXT AS sku_item_status, -- FIX: Explicitly cast item_status to TEXT
      sps.upc_12_digit AS sku_upc_12_digit
  FROM
      public.jt_deal_spec_price_sheet AS jtds
  JOIN
      public.spec_price_sheet AS sps ON jtds.sku_id = sps.id
  WHERE
      jtds.deal_id = p_deal_id
  ORDER BY
      sps.description ASC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_brand_by_id(brand_id uuid)
 RETURNS SETOF public.brands
 LANGUAGE sql
AS $function$
  select * from brands where id = brand_id;
$function$
;

CREATE OR REPLACE FUNCTION public.get_brand_skus_for_deal(p_brand uuid, p_deal uuid)
 RETURNS TABLE(sku_id uuid, sku_description text, jt_id uuid, status text, full_category text)
 LANGUAGE sql
 STABLE
AS $function$
  select 
    s.id, 
    s.description, 
    j.id, 
    j.sku_deal_status,
    -- The subquery for the category
    (
      select string_agg(mc.full_category, ', ')
      from jt_spec_price_sheet_categories jt
      join master_categories mc on mc.id = jt.category_id
      where jt.sku_id = s.id
    ) as full_category
  from spec_price_sheet s
  left join jt_associated_skus j
    on j.sku_id = s.id
    and j.deal_id = p_deal
  where s.brand_id = p_brand
  order by s.description;
$function$
;

CREATE OR REPLACE FUNCTION public.get_comments_for_activity_notes(p_activity_id uuid)
 RETURNS TABLE(comment_id uuid, content text, created_at timestamp with time zone, activity_id uuid, user_id uuid, username text, profile_photo text, full_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        c.id,                                         -- The comment's ID
        c.comment_text,                                    -- The comment's text
        c.created_at,                                 -- The comment's timestamp
        c.deal_id,                                -- The ID of the activity being commented on
        c.user_id,                                    -- The author's user ID from auth.users
        COALESCE(tmg.email, 'Anonymous User'),     -- The author's username, with a fallback
        COALESCE(tmg.profile_photo, 'default_profile_photo.png'), -- The author's avatar, with a fallback
        tmg.name                              -- Example: The author's full name from their profile        
    FROM
        "deal_activity_comments" AS c
    -- LEFT JOIN to the profile table to get display info like username
    LEFT JOIN
        "team_member_guide" AS tmg ON c.user_id = tmg.user_id
    -- LEFT JOIN to the auth table to get user-specific info like email
    WHERE
        c.deal_id = p_activity_id
    ORDER BY
        c.created_at DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_complete_schema()
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    result jsonb;
BEGIN
    -- Get all enums
    WITH enum_types AS (
        SELECT 
            t.typname as enum_name,
            array_agg(e.enumlabel ORDER BY e.enumsortorder) as enum_values
        FROM pg_type t
        JOIN pg_enum e ON t.oid = e.enumtypid
        JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = 'public'
        GROUP BY t.typname
    )
    SELECT jsonb_build_object(
        'enums',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', enum_name,
                    'values', to_jsonb(enum_values)
                )
            ),
            '[]'::jsonb
        )
    )
    FROM enum_types
    INTO result;

    -- Get all tables with their details
    WITH RECURSIVE 
    columns_info AS (
        SELECT 
            c.oid as table_oid,
            c.relname as table_name,
            a.attname as column_name,
            format_type(a.atttypid, a.atttypmod) as column_type,
            a.attnotnull as notnull,
            pg_get_expr(d.adbin, d.adrelid) as column_default,
            CASE 
                WHEN a.attidentity != '' THEN true
                WHEN pg_get_expr(d.adbin, d.adrelid) LIKE 'nextval%' THEN true
                ELSE false
            END as is_identity,
            EXISTS (
                SELECT 1 FROM pg_constraint con 
                WHERE con.conrelid = c.oid 
                AND con.contype = 'p' 
                AND a.attnum = ANY(con.conkey)
            ) as is_pk
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        LEFT JOIN pg_attribute a ON a.attrelid = c.oid
        LEFT JOIN pg_attrdef d ON d.adrelid = c.oid AND d.adnum = a.attnum
        WHERE n.nspname = 'public' 
        AND c.relkind = 'r'
        AND a.attnum > 0 
        AND NOT a.attisdropped
    ),
    fk_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', con.conname,
                    'column', col.attname,
                    'foreign_schema', fs.nspname,
                    'foreign_table', ft.relname,
                    'foreign_column', fcol.attname,
                    'on_delete', CASE con.confdeltype
                        WHEN 'a' THEN 'NO ACTION'
                        WHEN 'c' THEN 'CASCADE'
                        WHEN 'r' THEN 'RESTRICT'
                        WHEN 'n' THEN 'SET NULL'
                        WHEN 'd' THEN 'SET DEFAULT'
                        ELSE NULL
                    END
                )
            ) as foreign_keys
        FROM pg_class c
        JOIN pg_constraint con ON con.conrelid = c.oid
        JOIN pg_attribute col ON col.attrelid = con.conrelid AND col.attnum = ANY(con.conkey)
        JOIN pg_class ft ON ft.oid = con.confrelid
        JOIN pg_namespace fs ON fs.oid = ft.relnamespace
        JOIN pg_attribute fcol ON fcol.attrelid = con.confrelid AND fcol.attnum = ANY(con.confkey)
        WHERE con.contype = 'f'
        GROUP BY c.oid
    ),
    index_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', i.relname,
                    'using', am.amname,
                    'columns', (
                        SELECT jsonb_agg(a.attname ORDER BY array_position(ix.indkey, a.attnum))
                        FROM unnest(ix.indkey) WITH ORDINALITY as u(attnum, ord)
                        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = u.attnum
                    )
                )
            ) as indexes
        FROM pg_class c
        JOIN pg_index ix ON ix.indrelid = c.oid
        JOIN pg_class i ON i.oid = ix.indexrelid
        JOIN pg_am am ON am.oid = i.relam
        WHERE NOT ix.indisprimary
        GROUP BY c.oid
    ),
    policy_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', pol.polname,
                    'command', CASE pol.polcmd
                        WHEN 'r' THEN 'SELECT'
                        WHEN 'a' THEN 'INSERT'
                        WHEN 'w' THEN 'UPDATE'
                        WHEN 'd' THEN 'DELETE'
                        WHEN '*' THEN 'ALL'
                    END,
                    'roles', (
                        SELECT string_agg(quote_ident(r.rolname), ', ')
                        FROM pg_roles r
                        WHERE r.oid = ANY(pol.polroles)
                    ),
                    'using', pg_get_expr(pol.polqual, pol.polrelid),
                    'check', pg_get_expr(pol.polwithcheck, pol.polrelid)
                )
            ) as policies
        FROM pg_class c
        JOIN pg_policy pol ON pol.polrelid = c.oid
        GROUP BY c.oid
    ),
    trigger_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', t.tgname,
                    'timing', CASE 
                        WHEN t.tgtype & 2 = 2 THEN 'BEFORE'
                        WHEN t.tgtype & 4 = 4 THEN 'AFTER'
                        WHEN t.tgtype & 64 = 64 THEN 'INSTEAD OF'
                    END,
                    'events', (
                        CASE WHEN t.tgtype & 1 = 1 THEN 'INSERT'
                             WHEN t.tgtype & 8 = 8 THEN 'DELETE'
                             WHEN t.tgtype & 16 = 16 THEN 'UPDATE'
                             WHEN t.tgtype & 32 = 32 THEN 'TRUNCATE'
                        END
                    ),
                    'statement', pg_get_triggerdef(t.oid)
                )
            ) as triggers
        FROM pg_class c
        JOIN pg_trigger t ON t.tgrelid = c.oid
        WHERE NOT t.tgisinternal
        GROUP BY c.oid
    ),
    table_info AS (
        SELECT DISTINCT 
            c.table_oid,
            c.table_name,
            jsonb_agg(
                jsonb_build_object(
                    'name', c.column_name,
                    'type', c.column_type,
                    'notnull', c.notnull,
                    'default', c.column_default,
                    'identity', c.is_identity,
                    'is_pk', c.is_pk
                ) ORDER BY c.column_name
            ) as columns,
            COALESCE(fk.foreign_keys, '[]'::jsonb) as foreign_keys,
            COALESCE(i.indexes, '[]'::jsonb) as indexes,
            COALESCE(p.policies, '[]'::jsonb) as policies,
            COALESCE(t.triggers, '[]'::jsonb) as triggers
        FROM columns_info c
        LEFT JOIN fk_info fk ON fk.table_oid = c.table_oid
        LEFT JOIN index_info i ON i.table_oid = c.table_oid
        LEFT JOIN policy_info p ON p.table_oid = c.table_oid
        LEFT JOIN trigger_info t ON t.table_oid = c.table_oid
        GROUP BY c.table_oid, c.table_name, fk.foreign_keys, i.indexes, p.policies, t.triggers
    )
    SELECT result || jsonb_build_object(
        'tables',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', table_name,
                    'columns', columns,
                    'foreign_keys', foreign_keys,
                    'indexes', indexes,
                    'policies', policies,
                    'triggers', triggers
                )
            ),
            '[]'::jsonb
        )
    )
    FROM table_info
    INTO result;

    -- Get all functions
    WITH function_info AS (
        SELECT 
            p.proname AS name,
            pg_get_functiondef(p.oid) AS definition
        FROM pg_proc p
        JOIN pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
        AND p.prokind = 'f'
    )
    SELECT result || jsonb_build_object(
        'functions',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', name,
                    'definition', definition
                )
            ),
            '[]'::jsonb
        )
    )
    FROM function_info
    INTO result;

    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_customer_category_opportunities(customer_uuid uuid)
 RETURNS TABLE(review_id uuid, retailer_name text, gnf_category text, retailer_category text, submission_deadline date, days_remaining integer, urgency_level text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        cr.id,
        a.account,
        mc.full_category,
        cr.retailer_category,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        CASE 
            WHEN cr.new_item_submission_deadline < CURRENT_DATE THEN 'Expired'
            WHEN cr.new_item_submission_deadline <= CURRENT_DATE + 7 THEN 'Urgent'
            WHEN cr.new_item_submission_deadline <= CURRENT_DATE + 30 THEN 'Soon'
            ELSE 'Future'
        END
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    LEFT JOIN master_categories mc ON cr.master_category_id = mc.id
    JOIN jt_hh_customers_master_categories jcmc ON jcmc.customer_id = customer_uuid
    WHERE cr.master_category_id = jcmc.master_category_id
    AND cr.new_item_submission_deadline > CURRENT_DATE
    AND (cr.archive IS NOT TRUE OR cr.archive IS NULL)
    ORDER BY cr.new_item_submission_deadline;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_customer_monthly_status(customer_uuid uuid)
 RETURNS TABLE(customer_name text, contributions_this_month integer, status_message text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        c.name,
        COUNT(cont.id)::INTEGER,
        CASE 
            WHEN COUNT(cont.id) > 0 THEN '✅ At Least One Contribution'
            ELSE '❌ No Contribution This Month'
        END
    FROM hh_customers c
    LEFT JOIN hh_contributions cont ON c.id = cont.customer_id
        AND EXTRACT(MONTH FROM cont.created_at) = EXTRACT(MONTH FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM cont.created_at) = EXTRACT(YEAR FROM CURRENT_DATE)
    WHERE c.id = customer_uuid
    GROUP BY c.name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_dashboard_summary()
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
SELECT jsonb_build_object(
    -- 1. TOP TILES: COUNTS
    'counts', jsonb_build_object(
        'pipeline_items', (
            -- UPDATED: now pulls from your specific pipeline view
            -- (Assumes this view only shows active tasks. If it shows closed ones, add WHERE status != 'Closed')
            SELECT count(*) 
            FROM public.v_task_pipeline_with_assignees
            WHERE is_completed = false
        ),
        'planned_submissions', (
            SELECT count(*) 
            FROM public.planned_submissions 
        ),
        'sync_calls', (
            -- UPDATED: now pulls from your call schedule table
            SELECT count(*) 
            FROM public.brand_sync_call_schedule
            WHERE sync_date = CURRENT_DATE -- <--- VERIFY THIS COLUMN NAME (e.g. call_date, start_time)
        )
    ),

    -- 2. TILE: UPCOMING CATEGORY REVIEW
    'next_review', (
        SELECT jsonb_build_object(
            'review_name', review_name,
            'deadline', new_item_submission_deadline,
            'managers', category_managers,
            'brands', linked_brands_array,
            'count', linked_brands_count
        )
        FROM public.v_brand_matching
        WHERE new_item_submission_deadline IS NOT NULL 
          AND new_item_submission_deadline >= CURRENT_DATE
        ORDER BY new_item_submission_deadline ASC
        LIMIT 1
    ),

    -- 3. TILE: UPCOMING EVENT
    'next_event', (
        SELECT row_to_json(e)
        FROM (
            SELECT * FROM public.events_detailed_view
            WHERE start_date >= CURRENT_DATE
            ORDER BY start_date ASC
            LIMIT 1
        ) e
    ),

    -- 4. TILE: ANNOUNCEMENT
    'next_announcement', (
        SELECT row_to_json(a)
        FROM (
            SELECT * FROM public.company_announcements
            WHERE announcement_date >= CURRENT_DATE
              AND publish IS TRUE
              AND (archive IS NOT TRUE)
            ORDER BY announcement_date ASC
            LIMIT 1
        ) a
    ),

    -- 5. TILE: NEXT PLANNED SUBMISSION
    'next_planned_submission', (
        SELECT jsonb_build_object(
            'submission_id', ps.id,
            'planned_date', ps.planned_submission_date,
            'submission_status', ps.submission_status,
            'review_name', mcrd.display_name,
            'brand_name', b.brand,
            'brand_logo', b.brand_logo,
            'deal_name', at.activity_name
        )
        FROM public.planned_submissions ps
        LEFT JOIN public.master_category_review_data mcrd ON ps.category_review = mcrd.id
        LEFT JOIN public.activity_tracker at ON ps.deal_id = at.id
        LEFT JOIN public.brands b ON at.brand = b.id
        WHERE ps.planned_submission_date >= CURRENT_DATE
          AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
        ORDER BY ps.planned_submission_date ASC
        LIMIT 1
    )
);
$function$
;

CREATE OR REPLACE FUNCTION public.get_deal_comments_by_brand(p_deal_id uuid)
 RETURNS TABLE(id uuid, deal_id uuid, user_id uuid, comment_text text, created_at timestamp with time zone, author_name text, author_profile_photo text, author_role_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT
      dac.id,
      dac.deal_id,
      dac.user_id,
      dac.comment_text,
      dac.created_at,
      -- Get author name: Prioritize name from team_member_guide IF the user is an internal team role, else use public.users name
      COALESCE(
          CASE WHEN r_sub.name IN ('internal', 'admin', 'manager') THEN tmg.name ELSE NULL END,
          pu.name
      ) AS author_name,
      -- Get profile photo URL: Only from team_member_guide if user is an internal team role, otherwise NULL
      CASE WHEN r_sub.name IN ('internal', 'admin', 'manager') THEN tmg.profile_photo ELSE NULL END AS author_profile_photo,
      r_sub.name AS author_role_name
  FROM
      public.deal_activity_comments AS dac
  JOIN
      public.users AS pu ON dac.user_id = pu.id
  LEFT JOIN (
      -- Corrected subquery to get a single, deterministic role name FOR EACH USER
      SELECT DISTINCT ON (ur_inner.user_id) -- FIX: Ensure one row per user_id
          ur_inner.user_id,
          r_inner.name
      FROM
          public.users_roles ur_inner
      JOIN
          public.roles r_inner ON ur_inner.role_id = r_inner.id
      ORDER BY
          ur_inner.user_id, -- Must be first for DISTINCT ON
          CASE r_inner.name
              WHEN 'admin' THEN 1
              WHEN 'manager' THEN 2
              WHEN 'internal' THEN 3
              ELSE 99
          END ASC
      -- Removed LIMIT 1 here, as DISTINCT ON handles the limiting per user_id
  ) AS r_sub ON pu.id = r_sub.user_id
  LEFT JOIN
      public.team_member_guide AS tmg ON pu.id = tmg.uuid AND r_sub.name IN ('internal', 'admin', 'manager')
  WHERE
      dac.deal_id = p_deal_id
  ORDER BY
      dac.created_at ASC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_demo_details(demo_id_param uuid)
 RETURNS TABLE(display_name text, brands text, account text, demo_date date, total_hours numeric, total_units_sold integer, demo_fee numeric, store_busy_rating integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT 
    (string_agg(b.brand, ' + ') || ' - ' || a.account || ' - ' || TO_CHAR(d.demo_date, 'MM/DD/YYYY'))::TEXT,
    string_agg(b.brand, ' + ')::TEXT,
    a.account::TEXT,
    d.demo_date,
    d.total_hours,
    d.total_units_sold,
    d.demo_fee,
    d.store_busy_rating
  FROM demos d
  LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
  LEFT JOIN brands b ON jdb.brand_id = b.id
  LEFT JOIN accounts a ON d.account_id = a.uuid
  WHERE d.id = demo_id_param
  GROUP BY a.account, d.demo_date, d.total_hours, d.total_units_sold, d.demo_fee, d.store_busy_rating;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_demo_metrics(demo_id_param uuid)
 RETURNS TABLE(demo_name text, brands text, store_name text, demo_date date, total_hours numeric, units_sold integer, demo_fee numeric, store_rating integer)
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN QUERY
  SELECT 
    (string_agg(b.brand, ' + ') || ' - ' || a.account || ' - ' || TO_CHAR(d.demo_date, 'MM/DD/YYYY'))::TEXT,
    string_agg(b.brand, ' + ')::TEXT,
    a.account::TEXT,
    d.demo_date,
    d.total_hours,
    d.total_units_sold,
    d.demo_fee,
    d.store_busy_rating
  FROM demos d
  LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
  LEFT JOIN brands b ON jdb.brand_id = b.id
  LEFT JOIN accounts a ON d.account_id = a.uuid
  WHERE d.id = demo_id_param
  GROUP BY a.account, d.demo_date, d.total_hours, d.total_units_sold, d.demo_fee, d.store_busy_rating;
END;$function$
;

CREATE OR REPLACE FUNCTION public.get_distinct_values(_table_name text, _column_name text)
 RETURNS TABLE(value text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    _dtype text;
BEGIN
    -- 1. Get the Data Type of the column first
    SELECT data_type INTO _dtype 
    FROM information_schema.columns 
    WHERE table_name = _table_name AND column_name = _column_name;

    -- 2. Build the query based on type
    -- SCENARIO A: It is a native Postgres Array (e.g., text[], uuid[])
    IF _dtype = 'ARRAY' THEN
        RETURN QUERY EXECUTE format(
            'SELECT DISTINCT unnest(%I)::text FROM %I WHERE %I IS NOT NULL ORDER BY 1 LIMIT 100',
            _column_name, _table_name, _column_name
        );

    -- SCENARIO B: It is JSONB (The complex object list)
    ELSIF _dtype = 'jsonb' THEN
        RETURN QUERY EXECUTE format(
            -- This logic tries to find a "name-like" key to display. 
            -- If it can't find 'name' or 'label', it falls back to the full text.
            'SELECT DISTINCT 
                CASE 
                    WHEN jsonb_typeof(elem) = ''object'' THEN 
                        COALESCE(elem->>''name'', elem->>''owner_name'', elem->>''sku_name'', elem->>''category_name'', elem->>''program'', elem::text)
                    ELSE elem::text 
                END
             FROM %I, jsonb_array_elements(%I) as elem 
             LIMIT 100',
            _table_name, _column_name
        );

    -- SCENARIO C: Standard Text/Integer
    ELSE
        RETURN QUERY EXECUTE format(
            'SELECT DISTINCT %I::text FROM %I WHERE %I IS NOT NULL ORDER BY 1 LIMIT 100', 
            _column_name, _table_name, _column_name
        );
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_dynamic_data(_table_name text, _filters jsonb DEFAULT '[]'::jsonb, _limit integer DEFAULT 50, _offset integer DEFAULT 0)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    _query text;
    _filter_sql text := ' WHERE 1=1 '; 
    _filter_obj jsonb;
    _col text;
    _op text;
    _val text;
    _result jsonb;
BEGIN
    FOR _filter_obj IN SELECT * FROM jsonb_array_elements(_filters)
    LOOP
        _col := _filter_obj->>'col';
        _op  := _filter_obj->>'op';
        _val := _filter_obj->>'val';

        -- FIX: We add ::text to %I so UUIDs correspond correctly to the input text
        IF _op = 'eq' THEN
            _filter_sql := _filter_sql || format(' AND %I::text = %L', _col, _val);
            
        ELSIF _op = 'ilike' THEN 
            _filter_sql := _filter_sql || format(' AND %I::text ILIKE %L', _col, '%' || _val || '%');
            
        ELSIF _op = 'in' THEN 
            -- The magic fix for Multi-selects
            _filter_sql := _filter_sql || format(' AND %I::text = ANY(string_to_array(%L, '',''))', _col, _val);
            
        -- Numeric comparisons don't use ::text because math requires numbers
        ELSIF _op = 'gt' THEN
            _filter_sql := _filter_sql || format(' AND %I > %L', _col, _val);
        ELSIF _op = 'lt' THEN
            _filter_sql := _filter_sql || format(' AND %I < %L', _col, _val);
        END IF;
    END LOOP;

    _query := format('SELECT jsonb_agg(t) FROM (SELECT * FROM %I %s LIMIT %L OFFSET %L) t', _table_name, _filter_sql, _limit, _offset);
    EXECUTE _query INTO _result;
    RETURN COALESCE(_result, '[]'::jsonb);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_dynamic_data(_table_name text, _filters jsonb DEFAULT '[]'::jsonb, _limit integer DEFAULT 150, _offset integer DEFAULT 0, _logic text DEFAULT 'AND'::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    _query text;
    _filter_sql text;
    _filter_obj jsonb;
    _col text;
    _op  text;
    _val text;
    _sep text; -- Separator (AND / OR)
    _result jsonb;
BEGIN
    -- 1. Determine starting point based on logic
    IF _logic = 'OR' THEN
        _filter_sql := ' WHERE 1=0 '; -- Start false so "OR" can make it true
        _sep := ' OR ';
    ELSE
        _filter_sql := ' WHERE 1=1 '; -- Start true so "AND" can restrict it
        _sep := ' AND ';
    END IF;

    -- 2. Loop through filters
    FOR _filter_obj IN SELECT * FROM jsonb_array_elements(_filters)
    LOOP
        _col := _filter_obj->>'col';
        _op  := _filter_obj->>'op';
        _val := _filter_obj->>'val';

        -- 3. Append condition using the dynamic separator (_sep)
        
        -- EQUALS (=)
        IF _op = 'eq' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text = %L', _col, _val);
        
        -- DOES NOT EQUAL (!=)
        ELSIF _op = 'neq' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text <> %L', _col, _val);

        -- CONTAINS (ilike)
        ELSIF _op = 'ilike' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, '%' || _val || '%');

        -- DOES NOT CONTAIN (not ilike)
        ELSIF _op = 'not_ilike' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text NOT ILIKE %L', _col, '%' || _val || '%');

        -- STARTS WITH
        ELSIF _op = 'starts_with' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, _val || '%');

        -- ENDS WITH
        ELSIF _op = 'ends_with' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, '%' || _val);

        -- IS EMPTY (Null or Empty String)
        ELSIF _op = 'is_empty' THEN
            _filter_sql := _filter_sql || _sep || format('(%I IS NULL OR %I::text = '''')', _col, _col);

        -- IS NOT EMPTY
        ELSIF _op = 'is_not_empty' THEN
            _filter_sql := _filter_sql || _sep || format('(%I IS NOT NULL AND %I::text <> '''')', _col, _col);

        -- IS ONE OF (In Array)
        ELSIF _op = 'in' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text = ANY(string_to_array(%L, '',''))', _col, _val);

        -- GREATER THAN (>)
        ELSIF _op = 'gt' THEN
            _filter_sql := _filter_sql || _sep || format('%I > %L', _col, _val);

        -- GREATER OR EQUAL (>=)
        ELSIF _op = 'gte' THEN
            _filter_sql := _filter_sql || _sep || format('%I >= %L', _col, _val);

        -- LESS THAN (<)
        ELSIF _op = 'lt' THEN
            _filter_sql := _filter_sql || _sep || format('%I < %L', _col, _val);

        -- LESS OR EQUAL (<=)
        ELSIF _op = 'lte' THEN
            _filter_sql := _filter_sql || _sep || format('%I <= %L', _col, _val);

        END IF;
    END LOOP;

    -- 4. Execute
    _query := format('SELECT jsonb_agg(t) FROM (SELECT * FROM %I %s LIMIT %L OFFSET %L) t', _table_name, _filter_sql, _limit, _offset);
    EXECUTE _query INTO _result;
    
    RETURN COALESCE(_result, '[]'::jsonb);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_folder_path(target_folder_id uuid)
 RETURNS TABLE(id uuid, name text, level integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  WITH RECURSIVE folder_tree AS (
    -- Base case: start at the target folder
    SELECT f.id, f.name, f.parent_id, 1 as level
    FROM folders f
    WHERE f.id = target_folder_id
    
    UNION ALL
    
    -- Recursive step: climb up to the parent
    SELECT p.id, p.name, p.parent_id, ft.level + 1
    FROM folders p
    JOIN folder_tree ft ON ft.parent_id = p.id
  )
  -- Return results ordered from Root to Child (Home -> Folder)
  SELECT ft.id, ft.name, ft.level
  FROM folder_tree ft
  ORDER BY ft.level DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_grouped_syncup_notes(p_brand_id uuid DEFAULT NULL::uuid, p_account_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(formatted_date text, day_start text, daily_notes jsonb)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        TO_CHAR(DATE_TRUNC('day', note_details.sync_date), 'Mon DD,YYYY') AS formatted_date,
        TO_CHAR(DATE_TRUNC('day', note_details.sync_date), 'YYYY-MM-DD') AS day_start,
        JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id',                    note_details.uuid,
                'team_member_id',        note_details.team_member_uuid,
                'team_member_name',      note_details.team_member_name,
                'profile_photo',         note_details.profile_photo,
                'note',                  note_details.note,
                'sync_date',             note_details.sync_date, 
                'updated_at',            note_details.updated_at, 
                'user_id',               note_details.user_id,
                'associated_brands',     note_details.associated_brands,
                'associated_accounts',   note_details.associated_accounts 
            )
            ORDER BY note_details.sync_date ASC 
        ) AS daily_notes
    FROM (
        -- Select all relevant notes, join their user details, and aggregate their associated brands and accounts
        SELECT
            sn.uuid,
            sn.note,
            sn.sync_date,
            sn.updated_at,
            sn."user" AS user_id,
            tmg.uuid AS team_member_uuid,
            tmg.name AS team_member_name,
            tmg.profile_photo,
            (
                SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'jt_id', js_inner.id,
                                'brand_id', b_inner.id,
                                'brand_name', b_inner.brand
                            )
                            ORDER BY b_inner.brand
                        ) FILTER (WHERE b_inner.id IS NOT NULL)
                FROM public.jt_sync_up_notes_brands js_inner
                JOIN public.brands b_inner ON js_inner.brand_id = b_inner.id
                WHERE js_inner.note_id = sn.uuid
            ) AS associated_brands,
            (
                -- Corrected subquery to aggregate associated accounts
                SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'jt_id', ja_inner.id,
                                'account_id', a_inner.uuid, -- The UUID for the account
                                'account_name', a_inner.account -- *** CORRECTED COLUMN NAME IS 'account' ***
                            )
                            ORDER BY a_inner.account -- *** CORRECTED COLUMN NAME IS 'account' ***
                        ) FILTER (WHERE a_inner.uuid IS NOT NULL)
                FROM public.jt_sync_up_notes_accounts ja_inner
                JOIN public.accounts a_inner ON ja_inner.account_id = a_inner.uuid -- Join to the accounts table on UUID
                WHERE ja_inner.note_id = sn.uuid
            ) AS associated_accounts -- Corrected column
        FROM
            public.syncup_notes AS sn
        LEFT JOIN
            public.team_member_guide AS tmg ON sn.team_member = tmg.uuid
        WHERE
            -- Check for existence of EITHER a brand or an account association, if no brand/account filter is applied
            EXISTS (
                SELECT 1
                FROM public.jt_sync_up_notes_brands js_check_exists
                WHERE js_check_exists.note_id = sn.uuid
            )
            OR EXISTS (
                SELECT 1
                FROM public.jt_sync_up_notes_accounts ja_check_exists
                WHERE ja_check_exists.note_id = sn.uuid
            )
            -- Apply brand filter
            AND (
                p_brand_id IS NULL
                OR EXISTS (
                    SELECT 1
                    FROM public.jt_sync_up_notes_brands js_filter
                    WHERE js_filter.note_id = sn.uuid
                        AND js_filter.brand_id = p_brand_id
                )
            )
            -- Apply account filter 
            AND (
                p_account_id IS NULL
                OR EXISTS (
                    SELECT 1
                    FROM public.jt_sync_up_notes_accounts ja_filter
                    WHERE ja_filter.note_id = sn.uuid
                        AND ja_filter.account_id = p_account_id
                )
            )
    ) AS note_details
    GROUP BY DATE_TRUNC('day', note_details.sync_date)
    ORDER BY DATE_TRUNC('day', note_details.sync_date) DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_harvesthub_customers()
 RETURNS SETOF public.v_harvesthub_customer_datagrid
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT * FROM public.v_harvesthub_customer_datagrid;
$function$
;

CREATE OR REPLACE FUNCTION public.get_hh_system_stats()
 RETURNS TABLE(total_customers integer, active_customers integer, total_category_reviews integer, upcoming_deadlines integer, pending_contributions integer, active_experts integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INTEGER FROM hh_customers),
        (SELECT COUNT(*)::INTEGER FROM hh_customers WHERE status = 'active_customer'),
        (SELECT COUNT(*)::INTEGER FROM hh_category_reviews),
        (SELECT COUNT(*)::INTEGER FROM hh_category_reviews 
         WHERE new_item_submission_deadline BETWEEN CURRENT_DATE AND CURRENT_DATE + 30),
        (SELECT COUNT(*)::INTEGER FROM hh_contributions WHERE validation_status = 'pending_review'),
        (SELECT COUNT(*)::INTEGER FROM hh_community_experts WHERE status = 'active');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_loggedinbrandinfo(brand_id uuid)
 RETURNS SETOF public.brands
 LANGUAGE sql
AS $function$
  select * from brands where id = brand_id;
$function$
;

CREATE OR REPLACE FUNCTION public.get_next_announcement()
 RETURNS SETOF public.company_announcements
 LANGUAGE sql
 STABLE
AS $function$SELECT *
  FROM public.company_announcements
  WHERE announcement_date >= CURRENT_DATE
    AND publish IS TRUE
    AND (archive IS NOT TRUE)
  ORDER BY announcement_date ASC
  LIMIT 1;$function$
;

CREATE OR REPLACE FUNCTION public.get_next_category_review_deadline()
 RETURNS SETOF public.v_brand_matching
 LANGUAGE sql
 STABLE
AS $function$
  SELECT *
  FROM public.v_brand_matching
  WHERE 
    new_item_submission_deadline IS NOT NULL 
    AND new_item_submission_deadline >= CURRENT_DATE
  ORDER BY 
    new_item_submission_deadline ASC
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.get_next_event()
 RETURNS SETOF public.events_detailed_view
 LANGUAGE sql
AS $function$
  SELECT *
  FROM public.events_detailed_view -- It searches the "library" (your view)
  WHERE start_date >= CURRENT_DATE -- Finds ones that haven't happened
  ORDER BY start_date ASC           -- Puts the soonest one first
  LIMIT 1;                          -- And ONLY grabs that single one
$function$
;

CREATE OR REPLACE FUNCTION public.get_next_planned_submission()
 RETURNS TABLE(submission_id uuid, planned_date date, submission_status boolean, deal_id uuid, category_review_id uuid, review_name text, brand_name text, deal_name text, brand_logo text)
 LANGUAGE sql
 STABLE
AS $function$
  SELECT
    ps.id as submission_id,
    ps.planned_submission_date as planned_date,
    ps.submission_status,
    ps.deal_id,
    ps.category_review as category_review_id,
    mcrd.display_name as review_name,
    b.brand as brand_name,
    
    -- New Columns
    at.activity_name as deal_name,
    b.brand_logo as brand_logo

  FROM public.planned_submissions ps
  
  LEFT JOIN public.master_category_review_data mcrd
    ON ps.category_review = mcrd.id

  LEFT JOIN public.activity_tracker at
    ON ps.deal_id = at.id
    
  LEFT JOIN public.brands b
    ON at.brand = b.id

  WHERE
    ps.planned_submission_date >= CURRENT_DATE
    AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
  ORDER BY ps.planned_submission_date ASC
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.get_notes_by_brand_with_names(p_brand_uuid uuid)
 RETURNS TABLE(note_id uuid, note_content text, sync_date timestamp with time zone, brand_id uuid, brand_name text, team_member_id uuid, team_member_name text, team_member_profile_photo text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        sn.uuid AS note_id,
        sn.note AS note_content,
        sn.sync_date AS sync_date,
        sn.brand AS brand_id,
        b.brand AS brand_name,
        sn.team_member AS team_member_id,
        tmg.name AS team_member_name,
        tmg.profile_photo AS team_member_profile_photo
    FROM
        public.syncup_notes sn
    LEFT JOIN
        public.brands b ON sn.brand = b.id
    LEFT JOIN
        public.team_member_guide tmg ON sn.team_member = tmg.uuid
    WHERE
        p_brand_uuid IS NULL -- Still allow for a NULL UUID if you want to fetch all
        OR sn.brand = p_brand_uuid; -- Changed from ANY(p_brand_uuids) to direct comparison
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_notes_by_brand_with_names(p_brand_uuids uuid[])
 RETURNS TABLE(note_id uuid, note_content text, sync_date timestamp with time zone, brand_id uuid, brand_name text, team_member_id uuid, team_member_name text, team_member_profile_photo text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        sn.uuid AS note_id,
        sn.note AS note_content,
        sn.sync_date AS sync_date,
        sn.brand AS brand_id,
        b.brand AS brand_name,
        sn.team_member AS team_member_id,
        tmg.name AS team_member_name,
        tmg.profile_photo AS team_member_profile_photo
    FROM
        public.syncup_notes sn
    LEFT JOIN
        public.brands b ON sn.brand = b.id
    LEFT JOIN
        public.team_member_guide tmg ON sn.team_member = tmg.uuid
    WHERE
        p_brand_uuids IS NULL
        OR CARDINALITY(p_brand_uuids) = 0
        OR sn.brand = ANY(p_brand_uuids);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_related_skus(input_brand_id uuid)
 RETURNS TABLE(id uuid, description text, item_status text, upc_12_digit text)
 LANGUAGE sql
AS $function$
  select
    id,
    description,
    item_status,
    upc_12_digit
  FROM
    spec_price_sheet
  WHERE
    brand_id = input_brand_id;
$function$
;

CREATE OR REPLACE FUNCTION public.get_retailers_for_category(category_name text)
 RETURNS TABLE(retailer_name text, retailer_city text, store_count text, submission_deadline date, days_remaining integer, review_type text, retailer_category text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        a.account,
        a.city,
        a.store_count,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        cr.review_type,
        cr.retailer_category
    FROM hh_category_reviews cr
    JOIN accounts a ON cr.account_id = a.uuid
    WHERE cr.gnf_category ILIKE '%' || category_name || '%'
    AND cr.new_item_submission_deadline > CURRENT_DATE
    ORDER BY cr.new_item_submission_deadline;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_retailers_for_category(category_uuid uuid)
 RETURNS TABLE(retailer_name text, retailer_city text, store_count text, submission_deadline date, days_remaining integer, review_type text, retailer_category text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        a.account,
        a.city,
        a.store_count,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        cr.review_type,
        cr.retailer_category
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    WHERE cr.master_category_id = category_uuid
    AND cr.new_item_submission_deadline > CURRENT_DATE
    AND (cr.archive IS NOT TRUE OR cr.archive IS NULL)
    ORDER BY cr.new_item_submission_deadline;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_spec_price_sheets_by_brand(input_brand_id uuid)
 RETURNS SETOF public.spec_price_sheet
 LANGUAGE sql
AS $function$
  SELECT * FROM spec_price_sheet WHERE brand_id = input_brand_id;
$function$
;

CREATE OR REPLACE FUNCTION public.get_table_columns(_table_name text)
 RETURNS TABLE(column_name text, data_type text, display_name text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN QUERY
  SELECT 
    c.column_name::text, 
    c.data_type::text,
    
    -- THE PRETTY PRINTING LOGIC --
    TRIM(
      INITCAP(
        REPLACE(
          REPLACE(
             REPLACE(c.column_name, 'lk_', ''),    -- 1. Remove "lk_" prefix
             'filter_', ''),                       -- 2. Remove "filter_" prefix
          '_', ' '                                 -- 3. Turn underscores into spaces
        )
      )
    ) as display_name

  FROM information_schema.columns c
  WHERE c.table_name = _table_name
  AND c.table_schema = 'public'
  -- Exclude IDs and messy JSON objects you don't want in the dropdown
  AND c.column_name NOT IN ('id', 'uuid', 'account_address_details', 'master_category_reviews_array', 'deal_owners_array');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_task_dashboard_tab_counts()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
  result json;
BEGIN
  SELECT json_build_object(
    'this_week_overdue', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'this_week_overdue'),
    'next_two_weeks', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'next_two_weeks'),
    'this_month', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'this_month'),
    'to_watch', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'to_watch'),
    'sos_follow_up', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'sos_follow_up')
  ) INTO result;
  RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_task_stats()
 RETURNS TABLE(status public.kanban_status_enum, task_count bigint, overdue_count bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT 
    tp.status,
    COUNT(*) as task_count,
    COUNT(*) FILTER (WHERE tp.due_date < CURRENT_DATE) as overdue_count
  FROM task_pipeline tp
  WHERE tp.is_completed = false
  GROUP BY tp.status;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.global_search(search_term text, search_type text)
 RETURNS TABLE(id uuid, display_text text, result_type text, metadata jsonb)
 LANGUAGE plpgsql
AS $function$
DECLARE
    query_string TEXT;
BEGIN
    query_string := array_to_string(string_to_array(search_term, ' '), ' & ');

    CASE search_type
        WHEN 'brands' THEN
            RETURN QUERY
                SELECT
                    b.id,
                    b.brand AS display_text,
                    'Brand' AS result_type,
                    jsonb_build_object(
                        'services', b.services,
                        'company_website', b.company_website,
                        'manufacturer_name', b.manufacturer_name
                    ) AS metadata
                FROM public.brands b
                WHERE b.search_vector @@ to_tsquery('english', query_string);

        WHEN 'accounts' THEN
            RETURN QUERY
                SELECT
                    a.uuid AS id,
                    a.account AS display_text,
                    'Account' AS result_type,
                    jsonb_build_object(
                        'website', a.website,
                        'industry_tags', a.industry_tags,
                        'city', a.city,
                        'state', a.state
                    ) AS metadata
                FROM public.accounts a
                WHERE a.search_vector @@ to_tsquery('english', query_string);

        WHEN 'activities' THEN
            RETURN QUERY
                SELECT
                    at.id,
                    at.activity_name AS display_text,
                    'Activity' AS result_type,
                    jsonb_build_object(
                        'activity_type', at.activity_type,
                        'deal_stage', at.deal_stage,
                        'follow_up_date', at.follow_up_date,
                        'created_at', at.created_at,
                        -- Returns the raw UUIDs from the activity_tracker table
                        'brand_id', at.brand,
                        'account_id', at.account
                    ) AS metadata
                FROM public.activity_tracker at
                -- No JOINs in this version
                WHERE at.search_vector @@ to_tsquery('english', query_string);
    END CASE;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_employee_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.status != 'Active' AND OLD.status = 'Active' THEN
    -- Remove all roles for this user
    DELETE FROM public.users_roles
    WHERE user_id IN (
      SELECT id FROM auth.users 
      WHERE team_member_id = NEW.uuid
    );
    
    -- Log the deactivation
    INSERT INTO public.audit_log (action, team_member_id, timestamp)
    VALUES ('employee_deactivated', NEW.uuid, NOW());
  END IF;
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_hh_customers_audit()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
    -- Updates the timestamp to 'now'
    NEW.updated_at = now();

    -- Captures the Supabase Auth User ID
    -- Note: Will be NULL if updated via Dashboard or Service Role
    NEW.modified_by = auth.uid();

    RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_submission_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$begin
  -- IF STATUS CHANGED TO TRUE (Submitted)
  if (NEW.submission_status = true) 
     and (OLD.submission_status is distinct from NEW.submission_status) then
    
    NEW.submitted_date := now();
    NEW.submitted_by := auth.uid(); -- Sets it to the currently logged-in user

  -- IF STATUS CHANGED TO FALSE (Reverted)
  elsif (NEW.submission_status = false) 
        and (OLD.submission_status = true) then
    
    NEW.submitted_date := null;
    NEW.submitted_by := null;
    
  end if;

  return NEW;
end;$function$
;

CREATE OR REPLACE FUNCTION public.handle_task_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- If status changed to 'Completed' (Title Case)
    IF NEW.status = 'Completed' AND (OLD.status IS DISTINCT FROM 'Completed') THEN
        NEW.completed_date = NOW();
    
    -- If status changed FROM 'Completed' to something else (reopened)
    ELSIF NEW.status IS DISTINCT FROM 'Completed' AND OLD.status = 'Completed' THEN
        NEW.completed_date = NULL;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.import_airtable_task_tracker()
 RETURNS TABLE(imported_count integer, assigned_user_mappings text, brand_mappings text, errors text)
 LANGUAGE plpgsql
AS $function$
DECLARE
  import_count INTEGER := 0;
  user_mappings TEXT := '';
  brand_mappings TEXT := '';
  error_log TEXT := '';
BEGIN
  -- This function expects the CSV data to be loaded into a temporary table first
  -- We'll create the temp table structure matching the CSV
  
  CREATE TEMP TABLE IF NOT EXISTS temp_airtable_tasks (
    task TEXT,
    sales_team_email TEXT,
    sales_team TEXT,
    notes TEXT,
    task_type TEXT,
    status TEXT,
    due_date TEXT,
    priority TEXT,
    task_completed TEXT,
    attachments TEXT,
    created TEXT
  );
  
  -- Insert into task_pipeline from temp table
  INSERT INTO task_pipeline (
    task_title,
    notes,
    task_type,
    status,
    assigned_to,
    brand_id,
    due_date,
    priority,
    is_completed,
    attachments,
    source_type
  )
  SELECT 
    t.task,
    t.notes,
    CASE t.task_type
      WHEN 'Deal Activity' THEN 'deal_activity'::task_type_enum
      WHEN 'Category Review' THEN 'category_review'::task_type_enum
      WHEN 'Internal Task' THEN 'internal_task'::task_type_enum
      WHEN 'Data' THEN 'data'::task_type_enum
      WHEN 'Marketing / Design' THEN 'marketing_design'::task_type_enum
      ELSE 'internal_task'::task_type_enum
    END,
    CASE t.status
      WHEN 'This Week / Overdue' THEN 'this_week_overdue'::kanban_status_enum
      WHEN 'Next Two Weeks' THEN 'next_two_weeks'::kanban_status_enum
      WHEN 'This Month' THEN 'this_month'::kanban_status_enum
      WHEN 'To Watch' THEN 'to_watch'::kanban_status_enum
      WHEN 'SOS Follow Up' THEN 'sos_follow_up'::kanban_status_enum
      ELSE 'this_month'::kanban_status_enum
    END,
    tmg.uuid, -- assigned_to
    b.id, -- brand_id
    CASE 
      WHEN t.due_date IS NOT NULL AND t.due_date != '' 
      THEN to_date(t.due_date, 'MM/DD/YYYY')
      ELSE NULL
    END,
    CASE t.priority
      WHEN 'High' THEN 'high'::priority_enum
      WHEN 'Medium' THEN 'medium'::priority_enum
      WHEN 'Low' THEN 'low'::priority_enum
      ELSE 'medium'::priority_enum
    END,
    COALESCE(t.task_completed = 'Completed', false),
    CASE 
      WHEN t.attachments IS NOT NULL AND t.attachments != ''
      THEN jsonb_build_array(
        jsonb_build_object(
          'filename', split_part(t.attachments, ' ', 1),
          'url', regexp_replace(t.attachments, '.*\((.*)\).*', '\1')
        )
      )
      ELSE '[]'::jsonb
    END,
    'manual'::source_type_enum
  FROM temp_airtable_tasks t
  LEFT JOIN team_member_guide tmg ON (
    tmg.name = t.sales_team OR 
    tmg.email = t.sales_team_email
  )
  LEFT JOIN brands b ON b.brand = t.task; -- This might need adjustment based on data
  
  GET DIAGNOSTICS import_count = ROW_COUNT;
  
  -- Generate mapping reports
  SELECT string_agg(DISTINCT 
    t.sales_team || ' (' || t.sales_team_email || ') -> ' || 
    COALESCE(tmg.name, 'NOT FOUND'), 
    E'\n'
  ) INTO user_mappings
  FROM temp_airtable_tasks t
  LEFT JOIN team_member_guide tmg ON (
    tmg.name = t.sales_team OR tmg.email = t.sales_team_email
  );
  
  DROP TABLE IF EXISTS temp_airtable_tasks;
  
  RETURN QUERY SELECT import_count, user_mappings, brand_mappings, error_log;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.import_airtable_tasks(p_task_data jsonb)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
  task_record JSONB;
  task_count INTEGER := 0;
  v_assigned_to UUID;
  v_brand_id UUID;
  v_account_id UUID;
  v_status kanban_status_enum;
  v_task_type task_type_enum;
  v_priority priority_enum;
BEGIN
  -- Process each task record
  FOR task_record IN SELECT * FROM jsonb_array_elements(p_task_data)
  LOOP
    -- Map assignee by name/email lookup
    SELECT uuid INTO v_assigned_to 
    FROM team_member_guide 
    WHERE name = task_record->>'sales_team_name' 
    OR email = task_record->>'sales_team_email'
    LIMIT 1;
    
    -- Map brand by name
    SELECT id INTO v_brand_id
    FROM brands
    WHERE brand = task_record->>'brand_name'
    LIMIT 1;
    
    -- Map status
    v_status := CASE task_record->>'status'
      WHEN 'This Week / Overdue' THEN 'this_week_overdue'
      WHEN 'Next Two Weeks' THEN 'next_two_weeks'
      WHEN 'This Month' THEN 'this_month'
      WHEN 'To Watch' THEN 'to_watch' 
      WHEN 'SOS Follow Up' THEN 'sos_follow_up'
      ELSE 'this_month'
    END;
    
    -- Map task type
    v_task_type := CASE task_record->>'task_type'
      WHEN 'Deal Activity' THEN 'deal_activity'
      WHEN 'Category Review' THEN 'category_review'
      WHEN 'Internal Task' THEN 'internal_task'
      WHEN 'Data' THEN 'data'
      WHEN 'Marketing / Design' THEN 'marketing_design'
      ELSE 'internal_task'
    END;
    
    -- Map priority
    v_priority := CASE task_record->>'priority'
      WHEN 'High' THEN 'high'
      WHEN 'Medium' THEN 'medium'
      WHEN 'Low' THEN 'low'
      ELSE 'medium'
    END;
    
    -- Insert task
    INSERT INTO task_pipeline (
      task_title,
      notes,
      task_type,
      status,
      assigned_to,
      brand_id,
      due_date,
      priority,
      is_completed,
      source_type
    ) VALUES (
      task_record->>'task',
      task_record->>'notes',
      v_task_type,
      v_status,
      v_assigned_to,
      v_brand_id,
      (task_record->>'due_date')::DATE,
      v_priority,
      COALESCE((task_record->>'task_completed')::BOOLEAN, false),
      'manual'
    );
    
    task_count := task_count + 1;
  END LOOP;
  
  RETURN task_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.insert_sku_placements_from_activity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    sku_id TEXT;
    sku_array TEXT[];
BEGIN
    -- Delete old placements for this deal to avoid duplicates
    DELETE FROM sku_placements WHERE deal_activity_id = NEW.id;

    -- Parse comma-separated UUIDs into array
    sku_array := string_to_array(NEW.associated_skus, ',');

    -- Loop through each and insert new row
    FOREACH sku_id IN ARRAY sku_array LOOP
        INSERT INTO sku_placements (deal_activity_id, spec_id, placement_type)
        VALUES (
            NEW.id,
            trim(sku_id),  -- ensure no extra spaces
            NEW.sku_placement_type
        );
    END LOOP;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_active_employee(user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM auth.users u
    JOIN public.team_member_guide tmg ON u.team_member_id = tmg.uuid
    WHERE u.id = user_id
    AND tmg.status = 'Active'
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_user_assigned_to_task(p_task_id uuid)
 RETURNS boolean
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM jt_task_assignments
    WHERE
      task_id = p_task_id AND
      team_member_uuid = (SELECT uuid FROM team_member_guide WHERE user_id = auth.uid())
  );
$function$
;

CREATE OR REPLACE FUNCTION public.link_brand_match_to_reviews()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- Insert a new record into the matched table for EVERY review found
  -- that shares the same master_category_id as the new brand.
  INSERT INTO public.jt_matched_brands_to_category_reviews (brand_match_id, review_id)
  SELECT 
      NEW.id,       -- The ID of the brand/category link just created
      r.id          -- The ID of the review found
  FROM 
      public.master_category_review_data r
  WHERE 
      r.master_category_id = NEW.master_category_id
  -- If this link already exists, just skip it (requires the constraint from Step 1)
  ON CONFLICT ON CONSTRAINT unique_brand_review_match DO NOTHING;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_deal_stage_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  if old.deal_stage is distinct from new.deal_stage then
    insert into public.deal_stage_history (
      activity_id,
      old_deal_stage_ref,
      new_deal_stage_ref,
      activity_notes,
      changed_by,
      changed_at
    ) values (
      new.id,
      old.deal_stage,
      new.deal_stage,
      new.activity_notes,
      new.last_modified_by,
      now()
    );
  end if;

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.new_activity_mention()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
  sender_name text;
  -- Variables for the data we look up
  var_activity_title text;
  var_note_snippet text;
  var_account_id uuid;
  var_brand_id uuid;
BEGIN
  -- 1. Get Sender Name
  SELECT name INTO sender_name 
  FROM team_member_guide WHERE uuid = auth.uid(); 
  
  IF sender_name IS NULL THEN sender_name := 'Someone'; END IF;

  -- 2. Get Activity Details (Title, Snippet, AND IDs) all at once
  -- Make sure column names 'account_id' and 'brand_id' match your table exactly!
  SELECT 
    activity_name,
    account,
    brand,
    LEFT(activity_notes, 50) || '...'
  INTO 
    var_activity_title,
    var_account_id,
    var_brand_id,
    var_note_snippet
  FROM activity_tracker 
  WHERE id = NEW.activity_id;

  -- 3. Insert with Extended Payload
  INSERT INTO public.notifications (
    recipient_id,
    type,
    data,
    status
  )
  VALUES (
    NEW.user_id,
    'activity_mention', 
    jsonb_build_object(
      -- === BACKWARD COMPATIBILITY ===
      'message', '<b>' || sender_name || '</b> mentioned you in <b>' || COALESCE(var_activity_title, 'an activity') || '</b>: ' || COALESCE(var_note_snippet, ''),

      -- === NAVIGATION DATA ===
      'activity_id', NEW.activity_id,
      'account_id', var_account_id,  -- Added
      'brand_id', var_brand_id,      -- Added
      
      -- === DISPLAY DATA ===
      'mention_id', NEW.id,
      'sender_name', sender_name,
      'display_title', sender_name || ' mentioned you in ' || COALESCE(var_activity_title, 'an activity'),
      'display_body', COALESCE(var_note_snippet, 'Check the activity for details.'),
      'triggered_at', now()
    ),
    'unread'
  );
  
  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.notify_hh_customer_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF OLD.status != NEW.status THEN
        -- Send notification (webhook/email integration point)
        PERFORM pg_notify('hh_customer_status_change', 
            json_build_object(
                'customer_id', NEW.id,
                'customer_name', NEW.name,
                'old_status', OLD.status,
                'new_status', NEW.status,
                'email', NEW.email,
                'company', NEW.company
            )::TEXT
        );
    END IF;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_task_assignment()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
  t_title text;
  creator_uuid uuid;
  creator_name text;
  t_status text;
  full_message text;
begin
  -- Get task title + creator UUID + status from task_pipeline
  select tp.task_title, tp.created_by, tp.status
  into t_title, creator_uuid, t_status
  from task_pipeline tp
  where tp.id = new.task_id;

  -- Get creator name from team_member_guide
  select tmg.name
  into creator_name
  from team_member_guide tmg
  where tmg.uuid = creator_uuid;

-- Convert snake_case status to Title Case
t_status := replace(initcap(replace(t_status, '_', ' ')), ' ', ' ');

  -- Build dynamic message
  full_message :=
    '<b>' || creator_name || '</b>' ||
    ' has assigned you the task ' ||
    '<b>' || t_title || '</b>' ||
    ' with ' ||
    '<b>' || t_status || '</b>' ||
    ' status.';

  -- Insert notification
  insert into notifications (recipient_id, type, data)
  values (
    new.team_member_uuid, -- the assigned user
    'task_assigned',       -- type
    jsonb_build_object(
      'task_id', new.task_id,
      'task_title', t_title,
      'task_status', t_status,
      'assigned_by_uuid', creator_uuid,
      'assigned_by_name', creator_name,
      'message', full_message
    )
  );

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.refresh_all_review_data_names()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    updated_count INTEGER := 0;
    review_record RECORD;
BEGIN
    FOR review_record IN 
        SELECT id FROM master_category_review_data
    LOOP
        UPDATE master_category_review_data 
        SET name = generate_review_data_name(review_record.id)
        WHERE id = review_record.id;
        
        updated_count := updated_count + 1;
    END LOOP;
    
    RETURN updated_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.search_similar_accounts(search_term text)
 RETURNS TABLE(uuid uuid, account_name text, similarity_score real)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT a.uuid, a.account, 
         similarity(a.account, search_term) as score
  FROM accounts a
  WHERE similarity(a.account, search_term) > 0.3
  ORDER BY score DESC
  LIMIT 10;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_assignee_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  if new.assignee_user_id is null then
    new.assignee_name := null;
    return new;
  end if;

  select tm.name
  into new.assignee_name
  from team_member_guide tm
  where tm.uuid = new.assignee_user_id;

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.set_brand_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  if new.brand_uuid is null then
    new.brand_name := null;
    return new;
  end if;

  select b.brand
  into new.brand_name
  from brands b
  where b.id = new.brand_uuid;

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.set_last_modified()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
  -- Sets the timestamp to the current time
  NEW.updated_at = now();
  
  -- Captures the UUID of the user making the request via Supabase Auth
  -- This will be NULL if the change is made via the Dashboard/Service Role
  NEW.modified_by = auth.uid();
  
  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.set_unique_category_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    account_name TEXT;
BEGIN
    -- Get account name
    SELECT a.account INTO account_name
    FROM accounts a 
    WHERE a.uuid = NEW.account;
    
    -- Set unique category name as "Account - Category Name"
    NEW.unique_category_name := COALESCE(account_name, 'Unknown') || ' - ' || COALESCE(NEW.retailer_category_name, '');
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.subscribe_customer_to_category_review(customer_uuid uuid, review_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO jt_hh_customers_category_reviews (customer_id, category_review_id)
    VALUES (customer_uuid, review_uuid)
    ON CONFLICT (customer_id, category_review_id) DO NOTHING;
    
    RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_brand_onboarding_tasks()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
    template_record RECORD;
BEGIN
    -- Loop through all Active Templates that match the Brand's new services
    FOR template_record IN
        SELECT 
            t.uuid AS template_id,
            t.title,
            t.description,
            t.is_required,
            type.code AS type_code
        FROM public.brand_task_templates t
        JOIN public.brand_task_types type ON t.task_type_uuid = type.uuid
        WHERE t.is_active = true 
        AND t.applies_to_services && NEW.services
    LOOP
        -- Dedupe Rule: Check if this task type already exists for this brand
        IF NOT EXISTS (
            SELECT 1 
            FROM public.brand_tasks bt
            WHERE bt.brand_uuid = NEW.id
            AND bt.task_type_code_readonly = template_record.type_code
        ) THEN
            -- Create the task
            INSERT INTO public.brand_tasks (
                brand_uuid,
                source,
                template_uuid,
                task_type_code_readonly,
                title_readonly_if_from_template,
                description_readonly_if_from_template,
                status,
                due_date
            ) VALUES (
                NEW.id,
                'Template',     -- Matches your "source" screenshot
                template_record.template_id,
                template_record.type_code,
                template_record.title,
                template_record.description,
                'Not Started',  -- Matches your "status" screenshot
                CURRENT_DATE + 10 
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.sync_gnf_primary()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    UPDATE accounts
    SET GNF_Primary = NEW.team_member_uuid
    WHERE uuid = NEW.account_uuid;

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.sync_new_account_to_partners()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
  INSERT INTO interaction_partners (partner_name, partner_type, original_record_id)
  VALUES (NEW.account, 'Retailer', NEW.uuid);
  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.sync_new_distributor_to_partners()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  INSERT INTO interaction_partners (partner_name, partner_type, original_record_id)
  VALUES (NEW.distributor, 'Distributor', NEW.id);
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_team_member_photo_to_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  UPDATE public.profiles
  SET profile_photo = NEW.profile_photo
  WHERE id = NEW.uuid; 
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_team_member_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  -- Update both the photo and the name in the profiles table
  update public.profiles
  set 
    profile_photo = new.profile_photo,
    name = new.name
  where id = new.uuid; 
  
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.test_name_generation()
 RETURNS TABLE(review_id uuid, current_name text, generated_name text, names_match boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        mcrd.id,
        mcrd.name,
        generate_review_data_name(mcrd.id),
        (mcrd.name = generate_review_data_name(mcrd.id))
    FROM master_category_review_data mcrd
    LIMIT 10;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trg_sku_placements_update_deal()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Always update the current or old deal ID
    PERFORM update_deal_placement_type(COALESCE(NEW.deal_activity_id, OLD.deal_activity_id));
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trg_task_pipeline_inserts()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Call your EXISTING determine_task_status function for manual tasks
    -- We pass NULL for the activity tracker ID, and the new due date
    NEW.status = determine_task_status(NULL, NEW.due_date);
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trg_task_pipeline_updates()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  
  -- Auto-update status for manual tasks based on due date changes
  IF NEW.due_date IS DISTINCT FROM OLD.due_date 
     AND NEW.category_review_id IS NULL THEN
     
     -- Check if there are NO deals attached via the junction table
     IF NOT EXISTS (SELECT 1 FROM public.jt_deal_task_pipeline WHERE task_id = NEW.id) THEN
        NEW.status = determine_task_status(NULL, NEW.due_date);
     END IF;
  END IF;
  
  -- Set completion timestamp
  IF NEW.is_completed = true AND OLD.is_completed = false THEN
    NEW.completed_at = NOW();
  ELSIF NEW.is_completed = false AND OLD.is_completed = true THEN
    NEW.completed_at = NULL;
  END IF;
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_accounts_search_vector()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.account, '') || ' ' ||
            COALESCE(NEW.account_description, '') || ' ' ||
            COALESCE(NEW.city, '') || ' ' ||
            COALESCE(NEW.state::text, '') || ' ' ||
            COALESCE(array_to_string(NEW.industry_tags, ' '), '')
        );
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_activity_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.brand IS NOT NULL AND NEW.account IS NOT NULL THEN
    SELECT COALESCE(b.brand, 'Unknown Brand') || ' - ' || COALESCE(a.account, 'Unknown Account')
    INTO NEW.activity_name
    FROM brands b, accounts a
    WHERE b.id = NEW.brand AND a.uuid = NEW.account;
  END IF;
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_activity_tracker_search_vector()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.activity_name, '') 
        );
    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.update_affected_review_names_from_categories()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Find affected review data records through the retailer matching
    FOR affected_review_id IN
        SELECT DISTINCT jm.review_data_id
        FROM jt_master_category_review_data_matching jm
        WHERE jm.retailer_matching_id = COALESCE(NEW.retailer_category_id, OLD.retailer_category_id)
    LOOP
        UPDATE master_category_review_data 
        SET name = generate_review_data_name(affected_review_id)
        WHERE id = affected_review_id;
    END LOOP;
    
    RETURN COALESCE(NEW, OLD);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_affected_review_names_from_matching()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Update display names for all review data linked to this retailer matching
    FOR affected_review_id IN 
        SELECT DISTINCT review_data_id 
        FROM jt_master_category_review_data_matching 
        WHERE retailer_matching_id = COALESCE(NEW.id, OLD.id)
    LOOP
        UPDATE master_category_review_data 
        SET display_name = generate_review_data_name(affected_review_id)
        WHERE id = affected_review_id;
    END LOOP;
    
    RETURN COALESCE(NEW, OLD);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_brands_search_vector()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.brand, '') || ' ' ||
            COALESCE(NEW.manufacturer_name, '') || ' ' ||
            COALESCE(NEW.main_poc_name, '') || ' ' ||
            COALESCE(NEW.company_website, '') || ' ' ||
            COALESCE(array_to_string(NEW.services, ' '), '')
        );
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_connect_count()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- If connect_stage contains "Connect ", set connect_count to 1
    IF NEW.connect_stage::text LIKE 'Connect %' THEN
        NEW.connect_count = 1;
    ELSE
        -- Otherwise (if it doesn't contain "Connect "), set connect_count to 0
        NEW.connect_count = 0;
    END IF;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_contribution_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.contribution_status = CASE 
        WHEN EXTRACT(MONTH FROM NEW.created_at) = EXTRACT(MONTH FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM NEW.created_at) = EXTRACT(YEAR FROM CURRENT_DATE)
        THEN '✅ Submitted This Month'
        ELSE '❌ No Submission This Month'
    END;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_demos_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_full_category()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.full_category = CASE 
        WHEN NEW.subcategory IS NOT NULL THEN NEW.category::TEXT || ' - ' || NEW.subcategory
        ELSE NEW.category::TEXT
    END;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_full_name_and_account()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE contacts
  SET full_name_and_account = CONCAT(
    NEW.first_name, ' ', NEW.last_name, ' - ',
    (SELECT account FROM accounts WHERE uuid = NEW.account_uuid)
  )
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_full_name_job_title()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE contacts
  SET full_name_job_title = CONCAT(NEW.first_name, ' ', NEW.last_name, ' - ', NEW.job_title)
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_human_friendly_names()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    -- Update the account name based on the account_uuid
    NEW.account_name := (SELECT account FROM accounts WHERE accounts.uuid = NEW.account_uuid);

    -- Update the team member name based on the team_member_uuid
    NEW.team_member_name := (SELECT name  FROM "team_member_guide" WHERE "team_member_guide".uuid = NEW.team_member_uuid);

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.update_last_modified_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.last_modified = now();
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_last_updated_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.last_updated = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_name_and_title()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE contacts
  SET name_and_title = CONCAT(NEW.first_name, ' ', NEW.last_name, ' - ', NEW.job_title)
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_program_field()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  brand_name text;
  total_connects bigint;
BEGIN
  -- Get the brand name from brands table
  SELECT brand INTO brand_name FROM brands WHERE id = NEW.brand;

  -- Safely calculate the total connects
  total_connects := COALESCE(NEW.sponsored_connects, 0) + COALESCE(NEW.total_paid_connects_authorized, 0);

  -- Update the `program` field
  NEW.program := CONCAT(
    brand_name, ' - ',
    NEW.calling_month, ' - ',
    NEW.calling_year, ' - ',
    COALESCE(NEW.program_type[1], ''), ' - ',
    NEW.region, ' - ',
    total_connects::text
  );

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_promo_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  readable_account TEXT;
BEGIN
  SELECT a.account INTO readable_account
  FROM accounts a
  WHERE a.uuid = NEW.account;

  NEW.promo_name := readable_account || ' - ' || NEW.promo_type || ' - ' || NEW.effective_promo_month;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_review_data_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  account_name_text text;
BEGIN
  -- 1. Get the Account Name from the linked accounts table
  -- We use NEW.account because that is the incoming UUID
  SELECT account INTO account_name_text
  FROM public.accounts
  WHERE uuid = NEW.account;

  -- 2. Construct the string using the NEW data directly
  -- Using NEW.retailer_category ensures we capture the change immediately
  IF account_name_text IS NOT NULL AND NEW.retailer_category IS NOT NULL THEN
      NEW.display_name := account_name_text || ' - ' || NEW.retailer_category;
  
  ELSIF account_name_text IS NOT NULL THEN
      NEW.display_name := account_name_text || ' - Unknown Category';
  
  ELSE
      NEW.display_name := 'Unknown Account - Unknown Category';
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_review_names_when_account_changes()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Update all review data display names that reference this account
    UPDATE master_category_review_data 
    SET display_name = generate_review_data_name(id)
    WHERE account = NEW.uuid;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_review_names_when_category_changes()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Only update if subcategory or category actually changed
    IF OLD.subcategory != NEW.subcategory OR OLD.category != NEW.category THEN
        -- Find all affected review records
        FOR affected_review_id IN
            SELECT DISTINCT jm.review_data_id
            FROM jt_retailer_category_to_gn_categories jrg
            JOIN jt_master_category_review_data_matching jm ON jrg.retailer_category_id = jm.retailer_matching_id
            WHERE jrg.gn_category_id = NEW.id
        LOOP
            UPDATE master_category_review_data 
            SET name = generate_review_data_name(affected_review_id)
            WHERE id = affected_review_id;
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_sos_authorizations_connects_achieved()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- This block handles INSERTs and UPDATEs in activity_tracker
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        -- Update the relevant sos_authorization row using the new or old sos_authorizations ID
        UPDATE public.sos_authorizations sa
        SET connects_achieved = (
            SELECT COALESCE(SUM(at.connect_count), 0)
            FROM public.activity_tracker at
            WHERE at.sos_authorizations = NEW.sos_authorizations
        )
        WHERE sa.id = NEW.sos_authorizations;

        -- If the sos_authorizations ID changed in an UPDATE, also update the old one
        IF (TG_OP = 'UPDATE' AND OLD.sos_authorizations IS NOT NULL AND OLD.sos_authorizations <> NEW.sos_authorizations) THEN
            UPDATE public.sos_authorizations sa
            SET connects_achieved = (
                SELECT COALESCE(SUM(at_old.connect_count), 0)
                FROM public.activity_tracker at_old
                WHERE at_old.sos_authorizations = OLD.sos_authorizations
            )
            WHERE sa.id = OLD.sos_authorizations;
        END IF;

    -- This block handles DELETEs from activity_tracker
    ELSIF (TG_OP = 'DELETE') THEN
        -- Update the relevant sos_authorization row using the old sos_authorizations ID
        UPDATE public.sos_authorizations sa
        SET connects_achieved = (
            SELECT COALESCE(SUM(at_del.connect_count), 0)
            FROM public.activity_tracker at_del
            WHERE at_del.sos_authorizations = OLD.sos_authorizations
        )
        WHERE sa.id = OLD.sos_authorizations;
    END IF;

    RETURN NULL; -- AFTER triggers must return NULL
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_task_time_categories()
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
  UPDATE public.task_pipeline
  SET
    status = CASE
      WHEN due_date IS NULL THEN status
      WHEN due_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'this_week_overdue'
      WHEN due_date <= CURRENT_DATE + INTERVAL '14 days' THEN 'next_two_weeks'
      WHEN due_date <= CURRENT_DATE + INTERVAL '30 days' THEN 
      'this_month'
      ELSE status
    END
  WHERE
    is_completed = false ; -- Only update active tasks that are not deal_activity
END;$function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;


