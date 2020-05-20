dvblack <-"#172B4D"
dvgrey <- "#8B95A6"
bordergrey <-"#DADCE0"

colours = c("Retail" = "#6998E9",
            "Residential" = "#64B466",
            "Tourism" ="#ECB65E",
            "Workplace" = "#5EB6BE",
            "Transit" = "#9A6EBB",
            "Recreational" = "#CA637F")

fillcolours = c("Retail" = "#E1EBFB",
                "Residential" = "#E0F0E0",
                "Tourism" ="#FBF0DF",
                "Workplace" = "#DFF0F2",
                "Transit" = "#EBE2F1",
                "Recreational" = "#F4E0E5")

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

changelabels <- function(label){
  if (label == "baseline_year"){
   newlabel = "NORMAL WEEK 2019"
  } else if (label == "baseline_week"){
    newlabel= "2 WEEKS AGO"  
  } else if (label == "target_week"){
    newlabel = "1 WEEK AGO"  
  } else {newlabel = "NA"}
  
  return(newlabel)
}

week_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/week_comparison_data.csv")) %>%
  filter(measure != "baseline_year")%>%
  mutate(measure=unname(sapply(measure,changelabels)))

year_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/week_comparison_data.csv")) %>%
  filter(measure != "baseline_week")%>%
  mutate(measure=unname(sapply(measure,changelabels)))

################# Plot things up
labels <- week_comparison %>% filter(hour(timestamp) == 12) %>% select(day, hour) %>% distinct()

duo_plot <- function(dat1, dat2, type, baseline="#8B95A6", category,category_fill) {
  dummy <-tibble(c(0))
  # Get min/max and each dataset to get limits on axes
  limits <- c(
    min(min(filter(dat1, sa2_type == type)$pop_scaled), min(filter(dat2, sa2_type == type)$pop_scaled)),
    max(max(filter(dat1, sa2_type == type)$pop_scaled), max(filter(dat2, sa2_type == type)$pop_scaled))
    )
  
  dat1 <- dat1 %>% filter(sa2_type == type)
  dat2 <- dat2 %>% filter(sa2_type == type)
  weekend <- dat2 %>% filter(day=="Sat"|day=="Sun") %>% summarise(xmin=min(hour),xmax=max(hour))
  
  cowplot::plot_grid( ggplot(dat2) +
                       scale_color_manual(values=c(`NORMAL WEEK 2019`=baseline, `1 WEEK AGO`=category)) +
                      geom_rect(data =weekend , aes(xmin=xmin, xmax=xmax, ymin=-Inf,ymax=Inf), colour = NA, fill = category_fill)+
                       geom_line(aes(x=hour, y=pop_scaled, group=measure, color=measure)) +
                       theme_dv_lines +
                       scale_y_continuous(limits = limits) +
                       scale_x_continuous(breaks=labels$hour,
                                          labels=labels$day) +
                       labs(y="", x="", title = "1 WEEK AGO v NORMAL WEEK 2019")+
                       weekplot_theme,
                     
                       ggplot(dat1) +
                        geom_rect(data =weekend , aes(xmin=xmin, xmax=xmax, ymin=-Inf,ymax=Inf), colour = NA, fill = category_fill)+
                       geom_line(aes(x=hour, y=pop_scaled, group=measure, color=measure)) +
                       theme_dv_lines +
                       scale_y_continuous(limits = limits) +
                       scale_color_manual(values=c(`2 WEEKS AGO`=baseline, `1 WEEK AGO`=category)) +
                       scale_x_continuous(breaks=labels$hour,
                                          labels=labels$day) +
                       labs(y="", x="", title = "1 WEEK AGO v 2 WEEKS AGO")+
                       weekplot_theme,
                     
                     scale = 0.9
  )
  
}

categories = c("Recreational","Retail","Tourism", "Workplace","Residential","Transit")


for (cat in categories){
  duo_plot(week_comparison, year_comparison, cat, category=unname(colours[cat]),category_fill=unname(fillcolours[cat]))%>%
      ggsave(file=paste0("outputs/report_", TIMESTAMP,"/",cat,"_week_comparison_plot.svg"), width=328, height=228/2,units="mm")
}

