
INSERT INTO mobility_outputs.daily_sa2_mobility
SELECT days,
	sa2_2018,
	MAX(cnt_rr3) - MIN(cnt_rr3) AS minmax,
	STDDEV_POP(cnt_rr3) AS stdev
FROM (
	SELECT DATE_TRUNC('day', "timestamp") AS days, 
	sa2_2018, 
	SUM(cnt_rr3) AS cnt_rr3
	FROM (
		SELECT * 
		FROM population_outputs.hourly_sa2_dom_short_vis 
		WHERE EXTRACT(HOUR FROM timestamp) NOT IN (0, 1, 2, 3, 4)
		AND cnt_rr3 > 10
		AND sa2_2018 NOT IN (SELECT DISTINCT sa22018_code FROM metadata.conc WHERE sa22018_name SIMILAR TO '(Oceanic|Inlet|Inland water)%')
	) subset_hours
	GROUP BY timestamp, sa2_2018
) sum_segments
GROUP BY days, sa2_2018