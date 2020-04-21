
SELECT EXTRACT(WEEK FROM timestamp) AS week
	,EXTRACT(DOW FROM timestamp) AS dow
	,timestamp
	,regc2018_code
	,ROUND(mobility, 3) AS mobility
	FROM (
		SELECT timestamp
		,regc2018_code
		,segment
		,cnt / SUM(cnt) OVER (PARTITION BY regc2018_code, "timestamp") AS mobility
		FROM (
			SELECT regc2018_code
			,timestamp
			,segment
			,SUM(cnt::numeric) AS cnt
			FROM (
				SELECT *
				FROM population_outputs.hourly_sa2_dom_short_vis cnts
				-- Subset by sunday and thirteen
				RIGHT JOIN (
					SELECT MAX(timestamp) AS recent_sunday
					,MAX(timestamp) - INTERVAL '13 DAYS 21 HOURS' AS two_wks_earlier
					FROM population_outputs.hourly_sa2_dom_short_vis
					WHERE EXTRACT(DOW FROM timestamp) = 0
				) date_range
				ON cnts.timestamp BETWEEN date_range.two_wks_earlier AND date_range.recent_sunday
			) cnts
			-- Subset to non watery SA2s and add regc
			RIGHT JOIN (
				SELECT DISTINCT sa22018_code
				,sa22018_name
				,regc2018_code
				FROM metadata.conc
				WHERE sa22018_name NOT SIMILAR TO '(Oceanic|Inlet|Inland water)%'
			) geo
			ON geo.sa22018_code = cnts.sa2_2018
			WHERE segment != 'international'
			AND EXTRACT(HOUR FROM timestamp) NOT IN (0, 1, 2, 3, 4)
			GROUP BY regc2018_code, timestamp, segment
		) regc_cnts
	) mobility
	WHERE segment = 'domestic'