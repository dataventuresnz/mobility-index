library(tidyverse)
# library(ventuRes)
library(lubridate)
library(extrafont)
source("functions.R")

# Set up some colours and constants
  
bordersclose = ymd_hms("2020-03-19T00:00:00")
lv2start = ymd_hms("2020-03-21T00:00:00")
lv3start = ymd_hms("2020-03-23T00:00:00")
lv4start = ymd_hms("2020-03-25T00:00:00")
lv4end = ymd_hms("2020-04-28T00:00:00")
lv3end = ymd_hms("2020-05-14T00:00:00")

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

# Pull telco data
dat <- read_csv(paste0("outputs/report_", TIMESTAMP, "/sparkline_data.csv"))

# # Create plot. This one does not give us the coloured line
# 
#   sparkline_plot <-ggplot(dat,aes(x=timestamp,ymin=min(pop_scaled), ymax=pop_scaled, fill = sa2_type, colour = sa2_type )) +
#   scale_color_manual(values = colours) +
#   scale_fill_manual(values = fillcolours) +
#   geom_ribbon() + ## Add a ribbon which fills under the line with low opacity
#   facet_wrap(~sa2_type, ncol = 2, scales="free") + ## Create a separate plot for each place
#   theme_void() + ## theme_X has some default themes and void is the one that strips everything
#   # scale_y_continuous(limits=c(NA, 8)) + ## Set the same y-axis which squishes things down and makes room for text labels
#   geom_vline(xintercept = bordersclose, color=dvgrey, size = 0.1) + # The vertical lines....
#   geom_vline(xintercept = lv2start, color=dvgrey, size = 0.2) +
#   geom_vline(xintercept = lv3start, color=dvgrey, size = 0.3) +
#   geom_vline(xintercept = lv4start, color=dvgrey) +
#   geom_vline(xintercept = lv4end, size = 0.3) +
#   sparkline_theme
#   
# 
# ggsave(sparkline_plot, file="sparkline_plot.svg", width=10, height=8)
# 
# # This way, we lose the facets. but gain the control over line colours

getSegment <- function(segment){
   d <- dat %>% filter(sa2_type == segment)
  return(d)
}

limitz <- function(limits){
  newlimitz = c(limits[1],limits[2]+2.5)
  return(newlimitz)
}
makeplot <- function(segment){
  d <- getSegment(segment)
  
  myplot <- ggplot(d,aes(x=timestamp,ymin=min(pop_scaled)-1, y=pop_scaled, ymax=pop_scaled, fill = sa2_type, colour = sa2_type )) +
    scale_color_manual(values = colours) +
    scale_fill_manual(values = fillcolours) +
    # geom_ribbon(color=NA) +
    geom_ribbon(outline.type = "upper") + ## Add a ribbon which fills under the line with low opacity
    # geom_line() +
    scale_y_continuous(expand = c(0,0)) +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    # scale_y_continuous(limits=c(NA, 8)) + ## Set the same y-axis which squishes things down and makes room for text labels
    geom_vline(xintercept = bordersclose, color=dvgrey) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvgrey) +
    geom_vline(xintercept = lv3start, color=dvgrey) +
    geom_vline(xintercept = lv4start, colour = dvgrey) +
    geom_vline(xintercept = lv4end, colour = dvgrey) +
    geom_vline(xintercept = lv3end, colour = colours[segment]) +
    labs(y="", x="",title=segment)+
    sparkline_theme
  
  return(myplot)
}

p <- plot_grid(
  makeplot("Retail"),
  makeplot("Recreational"),
  makeplot("Residential"),
  makeplot("Tourism"),
  makeplot("Transit"),
  makeplot("Workplace"),
  ncol=2,
  scale = 0.95
)
p

ggsave(p, file=paste0("outputs/report_", TIMESTAMP, "/sparkline_plot.svg"), units = "mm", width=6*35.6, height=0.8*9*25.6) 
