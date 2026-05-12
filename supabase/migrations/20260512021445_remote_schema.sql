set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_next_category_review_deadline()
 RETURNS SETOF public.v_brand_matching
 LANGUAGE sql
 STABLE
AS $function$
  SELECT * FROM public.v_brand_matching
  WHERE new_item_submission_deadline IS NOT NULL
    AND new_item_submission_deadline >= CURRENT_DATE
  ORDER BY new_item_submission_deadline ASC
  LIMIT 1;
$function$
;


