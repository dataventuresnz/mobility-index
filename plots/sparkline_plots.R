library(tidyverse)
# library(ventuRes)
library(lubridate)
library(extrafont)
source("functions.R")
library(cowplot)

# Set up some colours and constants
  
bordersclose = ymd_hms("2020-03-19T00:00:00")
lv2start = ymd_hms("2020-03-21T00:00:00")
lv3start = ymd_hms("2020-03-23T00:00:00")
lv4start = ymd_hms("2020-03-25T00:00:00")
lv4end = ymd_hms("2020-04-28T00:00:00")
lv3end = ymd_hms("2020-05-14T00:00:00")

# colours = c("Retail" = "#6998E9",
#             "Residential" = "#64B466",
#             "Tourism" ="#ECB65E",
#             "Workplace" = "#5EB6BE",
#             "Transit" = "#9A6EBB",
#             "Recreational" = "#CA637F")
# 
# fillcolours = c("Retail" = "#E1EBFB",
#                 "Residential" = "#E0F0E0",
#                 "Tourism" ="#FBF0DF",
#                 "Workplace" = "#DFF0F2",
#                 "Transit" = "#EBE2F1",
#                 "Recreational" = "#F4E0E5")


# Pull telco data
dat <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/sparkline_data.csv"))

# This way, we lose the facets. but gain the control over line colours. Also gain control over  

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
    scale_fill_manual(values = colours) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_datetime(expand = c(0,0)) +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    geom_vline(xintercept = bordersclose, color=dvblack) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvblack) +
    geom_vline(xintercept = lv3start, color=dvblack) +
    geom_vline(xintercept = lv4start, colour = dvblack) +
    geom_vline(xintercept = lv4end, colour = dvblack) +
    geom_vline(xintercept = lv3end, colour = colours[segment]) +
    geom_ribbon(outline.type = "upper",alpha=0.1) + ## Add a ribbon which fills under the line with low opacity
    # labs(y="", x="",title=toupper(segment))+
    labs(y="", x="")+
    theme_dv_sparkline
  
  return(myplot)
}

plotem <- function(cat){
  makeplot(cat)%>%
    ggsave(file=paste0("outputs/report_", TIMESTAMP,"/sparklines/",toFname(cat),"-population.svg"), width=200, height=90,units="mm",bg = "transparent")
}

plotem("Retail")
plotem("Recreational")
plotem("Residential")
plotem("Tourism")
plotem("Transit")
plotem("Workplace")

