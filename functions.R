
get_range <- function(start, end, segment = FALSE) {
  if (segment == FALSE) {
    db_query_wrapper("SELECT sa2_type
                ,timestamp
                ,SUM(cnt_rr3) AS pop
                FROM (SELECT * FROM population_outputs.hourly_rto_dom_short_vis WHERE timestamp BETWEEN ?start AND ?end) pops
                RIGHT JOIN metadata.sa2_classifications areas
                ON pops.sa2_2018::text = areas.sa2_2018_code::text
                GROUP BY sa2_type, timestamp",
                     start=start,
                     end=end,
                     db = db
    )
  } else {
    db_query_wrapper("SELECT timestamp
                ,segment
                ,SUM(cnt_rr3) AS pop
                FROM (SELECT * FROM population_outputs.hourly_rto_dom_short_vis WHERE timestamp BETWEEN ?start AND ?end) pops
                GROUP BY timestamp, segment",
                     start=start,
                     end=end,
                     db = db
    )
  }
  
}

get_mobility <- function(conc = "sa2_type", period = '2019-01-01') {
  
  if(conc == "sa2_type") {
  return(
  db_query_wrapper("SELECT days
  ,sa2_type
  ,SUM(minmax) AS minmax
  ,SUM(stdev) AS stdev
  FROM mobility_outputs.daily_sa2_mobility ests
  INNER JOIN metadata.sa2_classifications geo
  ON ests.sa2_2018::text = geo.sa2_2018_code
                   GROUP BY days, sa2_type
                   HAVING days >= ?period",
                   period = period,
                   db = db
                   )
  )
    }
  
  if (conc == "council") {
    return(
    db_query_wrapper("SELECT days
    ,regc2018_name
    ,SUM(minmax) AS minmax
    ,SUM(stdev) AS stdev
    FROM mobility_outputs.daily_sa2_mobility ests
    LEFT JOIN (
    SELECT DISTINCT sa22018_code, regc2018_name 
    FROM metadata.conc
    ) geo
    ON ests.sa2_2018 = geo.sa22018_code
    GROUP BY days, regc2018_name
                     HAVING days >= ?period",
                       period = period,
                       db = db
      )
    )
    
  }
  
  if (conc == "national") {
    return(
      db_query_wrapper("SELECT days
    ,SUM(minmax) AS minmax
    ,SUM(stdev) AS stdev
    FROM mobility_outputs.daily_sa2_mobility ests
    GROUP BY days
                     HAVING days >= ?period",
                       period = period,
                       db = db
      ) 
    )
  }
  
  }

# Theming
theme_dv_lines <- theme_classic() +
  theme(
    axis.line.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    strip.background = element_blank(),
    plot.background = element_rect(colour = "grey", fill=NA, size=0.5),
    panel.spacing = unit(1, "lines"),
    legend.position="none"
  )