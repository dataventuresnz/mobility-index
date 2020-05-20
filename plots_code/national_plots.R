bordersclose = ymd_hms("2020-03-19T00:00:00")
lv2start = ymd_hms("2020-03-21T00:00:00")
lv3start = ymd_hms("2020-03-23T00:00:00")
lv4start = ymd_hms("2020-03-25T00:00:00")
lv4end = ymd_hms("2020-04-28T00:00:00")
lv3end = ymd_hms("2020-05-14T00:00:00")

dvblack <-"#172B4D"
dvgrey <- "#8B95A6"
bordergrey <-"#DADCE0"

sparkline_theme <- theme(
  line = element_line(colour = dvblack),
  text = element_text(family = "Poppins", colour = dvblack),
  plot.margin = margin(1.4, 1.4, 1.4, 1.4, "mm"),
  # panel.border = element_rect(colour = bordergrey, fill=NA, size=0.5), ## adds a grey box around each plot
  panel.spacing = unit(1, "lines"), ## Puts some more distance between each plot
  plot.title = element_text(margin=margin(0,0,40,0)),
  axis.line.y = element_blank(),
  axis.line.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks.y = element_blank(),
  panel.grid = element_blank(),
  strip.background = element_blank(),
  plot.background = element_rect(colour = bordergrey, fill=NA, size=0.5),
  # plot.background = element_blank(),
  legend.position="none"
)

weekplot_theme <- theme(
  line = element_line(colour = dvblack),
  text = element_text(family = "Poppins", colour = dvblack),
  plot.margin = margin(1.4, 1.4, 1.4, 1.4, "mm"),
  # panel.border = element_rect(colour = bordergrey, fill=NA, size=0.5), ## adds a grey box around each plot
  panel.spacing = unit(1, "lines"), ## Puts some more distance between each plot
  plot.title = element_text(margin=margin(0,0,40,0),size = 14),
  axis.line.y = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks.y = element_blank(),
  panel.grid = element_blank(),
  strip.background = element_blank(),
  plot.background = element_rect(colour = bordergrey, fill=NA, size=0.5),
  # plot.background = element_blank(),
  legend.title = element_blank(),
  legend.background = element_blank(),
  legend.box.background = element_blank(),
  legend.text = element_text(size=8),
  legend.key.height = unit(12,"pt"),
  legend.position=c(0.8, 1.2)
)

# Pull telco data
dat_counts <- read_csv(paste0("outputs/report_", TIMESTAMP, "/national_data.csv")) %>%
  filter(segment %in% c("domestic", "international")) %>%
  mutate(timestamp = as.Date(timestamp))

dat_mobility <- read_csv(paste0("outputs/report_", TIMESTAMP, "/mobility_national_data.csv")) %>%
  mutate(days = as.Date(days))

mobility_palette <- c(
  `orange` = "#EC927D",
  `light-orange` = "#FBE9E5"
)

xdateformat <- function(dat_counts){
  toupper(format(dat_counts,"%d\n%b"))
}

counts <- ggplot(dat_counts, aes(x=timestamp,ymin=0, ymax=pop, y=pop)) +
  geom_ribbon(color="#EC927D", fill="#FBE9E5", outline.type = "upper") + ## Add a ribbon which fills under the line with low opacity
  scale_y_continuous(expand = c(0,0), limits=c(0, 500000), labels = scales::comma) +
  scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat, limits = c(as.Date("2020-03-16"), as.Date("2020-05-18"))) +
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  geom_vline(xintercept = bordersclose, color=dvgrey) + # The vertical lines....
  geom_vline(xintercept = as.Date(lv2start), color=dvgrey) +
  geom_vline(xintercept = as.Date(lv3start), color=dvgrey) +
  geom_vline(xintercept = as.Date(lv4start), colour = dvgrey) +
  geom_vline(xintercept = as.Date(lv4end), colour = dvgrey) +
  geom_vline(xintercept = as.Date(lv3end), colour = "#EC927D") +
  labs(y="", x="") +
  mobility_theme +
  facet_wrap(~segment, scales="free_y")

ggsave(counts, file=paste0("outputs/report_", TIMESTAMP,"/national_counts_plot.svg"), width=328/2, height=228/4,units="mm")

mobility <- ggplot(dat_mobility,aes(x=days, y=mobility)) +
  geom_area(color="#EC927D", fill="#FBE9E5") +
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat) +
  scale_y_continuous(limits=c(-100, 100),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
  geom_vline(xintercept = bordersclose, color=dvgrey) + # The vertical lines....
  geom_vline(xintercept = as.Date(lv2start), color=dvgrey) +
  geom_vline(xintercept = as.Date(lv3start), color=dvgrey) +
  geom_vline(xintercept = as.Date(lv4start), colour = dvgrey) +
  geom_vline(xintercept = as.Date(lv4end), colour = dvgrey) +
  geom_vline(xintercept = as.Date(lv3end), colour = mobility_palette[1]) +
  labs(y="", x="",title=toupper("National Mobility"))+
  mobility_theme

ggsave(mobility, file=paste0("outputs/report_", TIMESTAMP,"/national_mobility_plot.svg"), width=164/2, height=114/2,units="mm")
