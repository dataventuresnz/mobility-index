
week_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/week_comparison_data.csv")) %>%
  filter(measure != "baseline_year")

year_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/week_comparison_data.csv")) %>%
  filter(measure != "baseline_week")


################# Plot things up
labels <- week_comparison %>% filter(hour(timestamp) == 12) %>% select(day, hour) %>% distinct()

duo_plot <- function(dat1, dat2, type, baseline="#8B95A6", category) {
  
  # Get min/max and each dataset to get limits on axes
  limits <- c(
    min(min(filter(dat1, sa2_type == type)$pop_scaled), min(filter(dat2, sa2_type == type)$pop_scaled)),
    max(max(filter(dat1, sa2_type == type)$pop_scaled), max(filter(dat2, sa2_type == type)$pop_scaled))
    )
  
  cowplot::plot_grid(dat2 %>%
                       filter(sa2_type == type) %>%
                       ggplot(aes(x=hour, y=pop_scaled, group=measure, color=measure)) +
                       scale_color_manual(values=c(`baseline_year`=baseline, `target_week`=category)) +
                       geom_line() +
                       theme_dv_lines +
                       scale_y_continuous(limits = limits) +
                       scale_x_continuous(breaks=labels$hour,
                                          labels=labels$day) +
                       labs(y="", x=""),
                     
                     dat1 %>%
                       filter(sa2_type == type) %>%
                       ggplot(aes(x=hour, y=pop_scaled, group=measure, color=measure)) +
                       geom_line() +
                       theme_dv_lines +
                       scale_y_continuous(limits = limits) +
                       scale_color_manual(values=c(`baseline_week`=baseline, `target_week`=category)) +
                       scale_x_continuous(breaks=labels$hour,
                                          labels=labels$day) +
                       labs(y="", x=""),
                     
                     scale = 0.9
  )
  
}

plot_grid(
  duo_plot(week_comparison, year_comparison, "Recreational", category="#CA637F"),
  duo_plot(week_comparison, year_comparison, "Retail", category="#6998E9"),
  duo_plot(week_comparison, year_comparison, "Tourism", category="#ECB65E"),
  duo_plot(week_comparison, year_comparison, "Workplace", category="#5EB6BE"),
  duo_plot(week_comparison, year_comparison, "Residential", category="#64B466"),
  duo_plot(week_comparison, year_comparison, "Transit", category="#9A6EBB"),
  ncol=1
  ) %>%
  ggsave(file=paste0("outputs/report_", TIMESTAMP, "/week_comparison_plot.svg"), width=10, height=12)
