library(tidyverse)
library(RPostgreSQL)

source("functions.R")

####### Get baseline data
baseline <- get_baseline()

####### Get latest two weeeks of data
latest <- get_latest() %>%
  mutate(week = ifelse(week == min(week), "base_week", "target_week")) %>% # Identifying the baseline week
  spread(week, mobility_average) %>%
  left_join(baseline, by=c("regc2018_code", "dow")) %>% # Add baseline year data
  mutate(week_change = (target_week - base_week) / base_week * 100, # Calculate percentage difference from each baseline
         year_change = (target_week - mobility_baseline) / mobility_baseline * 100) %>%
  select(regc2018_code, dow, year_change, week_change) %>%
  gather("baseline", "change", 3:4) %>%
  mutate(dow = ordered(dow, levels = c(1:6, 0), labels=c("Mon", "Tues", "Weds", "Thurs", "Fri", "Sat", "Sun")))

######## Create a single plot with the two baselines for testing
latest %>%
  group_by(regc2018_code, baseline) %>%
  summarise(change = round(mean(change, na.rm=TRUE), 1)) %>%
  ggplot(aes(x=regc2018_code, y=change, group=baseline, color=baseline)) +
  geom_point() +
  coord_flip()

######## Output a CSV of percentage changes
latest %>%
  group_by(regc2018_code, baseline) %>%
  summarise(change = round(mean(change, na.rm=TRUE), 1)) %>%
  spread(baseline, change) %>%
  write_csv("outputs/report_20200420/regc_percentages.csv")
