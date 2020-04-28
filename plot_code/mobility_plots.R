
################## Plot categories ----------------------------------
category_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/mobility_category_data.csv"))

category_comparison_plot <- category_comparison %>%
  filter(days > as.Date("2020-03-15")) %>%
  ggplot(aes(x=days, y=mobility, color=sa2_type, fill=sa2_type)) +
  scale_x_date(date_breaks = "weeks", date_labels = "%d-%b") +
  geom_hline(yintercept = 0, linetype="dashed") +
  scale_color_manual(values = category_palette) + 
  scale_fill_manual(values = category_light_palette) +
  geom_area() +
  geom_line() +
  theme_classic() +
  theme(strip.background = element_blank(),
        legend.position="none") +
  scale_y_continuous(limits = c(-100, 100)) +
  facet_wrap(~sa2_type,
             scales="free",
             ncol = 2)

ggsave(category_comparison_plot, file=paste0("outputs/report_", TIMESTAMP, "/mobility_category_plot.svg"), width=10, height=8)

################## Plot regional council ----------------------------------
council_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/mobility_council_data.csv"))

council_comparison_plot <- council_comparison %>%
  filter(days > as.Date("2020-03-15")) %>%
  ggplot(aes(x=days, y=mobility)) +
  geom_hline(yintercept = 0, linetype="dashed") +
  geom_area(fill=mobility_palette[2]) +
  geom_line(color=mobility_palette[1]) +
  scale_x_date(date_breaks = "weeks", date_labels = "%d-%b") +
  theme_classic() +
  theme(strip.background = element_blank(),
        legend.position="none") +
  scale_y_continuous(limits = c(-100, 100)) +
  facet_wrap(~regc2018_name,
             scales="free",
             ncol = 4)

ggsave(council_comparison_plot, file=paste0("outputs/report_", TIMESTAMP, "/mobility_council_plot.svg"), width=14, height=8)
