
/*Rolls up the hourly views into daily views*/

-- This query needs more polish because its drawing from a baseline table rather than view because the 2019 baseline doesnt change each week.
-- Therefore I wanted it to be more 'raw' to allow flexibility for other uses.
SELECT regc2018_code,
   DATE_PART('dow'::text, "timestamp") AS dow,
   AVG(mobility) AS mobility_baseline
  FROM mobility_outputs.hourly_sa2_dom_regc_mobility_baseline
 GROUP BY regc2018_code, (DATE_PART('dow'::text, "timestamp"));

-- This query has less expressions because the view its calling has more processing on it.
SELECT regc2018_code,
   week,
   dow,
   AVG(mobility) AS mobility_average
  FROM mobility_outputs.hourly_sa2_dom_regc_mobility_latest
 GROUP BY regc2018_code, week, dow;