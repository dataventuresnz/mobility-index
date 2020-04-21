SELECT timestamp
	,regc2018_code
	,ROUND(mobility, 3) AS mobility
	INTO hourly_sa2_dom_regc_mobility_baseline
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
			FROM population_outputs.hourly_sa2_dom_short_vis cnts
			RIGHT JOIN (
				SELECT DISTINCT sa22018_code
				,sa22018_name
				,regc2018_code
				FROM metadata.conc
				WHERE sa22018_name NOT SIMILAR TO '(Oceanic|Inlet|Inland water)%'
			) geo
			ON geo.sa22018_code = cnts.sa2_2018
			WHERE segment != 'international'
			GROUP BY regc2018_code, timestamp, segment
		) regc_cnts
		WHERE EXTRACT(HOUR FROM timestamp) NOT IN (0, 1, 2, 3, 4)
		AND EXTRACT(YEAR FROM timestamp) = 2019
	) mobility
	WHERE segment = 'domestic'