# mobility_theme <- theme(
#   line = element_line(colour = dvblack),
#   text = element_text(family = "Poppins", colour = dvblack),
#   plot.margin = margin(2, 2, 2, 2, "mm"),
#   # panel.border = element_rect(colour = bordergrey, fill=NA, size=0.5), ## adds a grey box around each plot
#   panel.spacing = unit(2, "lines"), ## Puts some more distance between each plot
#   plot.title = element_text(size= 12, margin=margin(0,0,25,0)),
#   axis.line.y = element_blank(),
#   axis.line.x = element_line(size=0.3),
#   axis.text.x = element_text(size = 6,margin=margin(4,0,0,0),family = "Poppins"),
#   axis.text.y = element_text(size = 6,margin=margin(4,3,0,0),family = "Poppins"),
#   axis.ticks.y = element_blank(),
#   axis.ticks.x = element_line(colour = dvblack, size = 0.3),
#   axis.ticks.length.x = unit(1,units="mm"),
#   panel.grid = element_blank(),
#   panel.grid.major.y = element_line(size = 0.3,colour =bordergrey),
#   strip.background = element_blank(),
#   plot.background = element_rect(colour = bordergrey, fill=NA, size=0.3),
#   # plot.background = element_blank(),
#   legend.position="none"
# )

# dvblack <-"#172B4D"
# dvgrey <- "#8B95A6"
# bordergrey <-"#DADCE0"
# 
# mobility_palette <- c(
#   `orange` = "#EC927D",
#   `light-orange` = "#FBE9E5"
# )
# 
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

bordersclose = ymd("2020-03-19")
lv2start = ymd("2020-03-21")
lv3start = ymd("2020-03-23")
lv4start = ymd("2020-03-25")
lv4end = ymd("2020-04-28")
lv3end = ymd("2020-05-14")

################## Plot categories ----------------------------------
category_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/mobility_category_data.csv"))

getCategory <- function(category){
  d <- category_comparison %>% filter(days > as.Date("2020-03-15")) %>% filter(sa2_type == category)
  return(d)
}

# xdateformat <- function(d){
#   toupper(format(d,"%d\n%b"))
# }

categoryPlot <- function(category){
  d <- getCategory(category)
  
  myplot <- ggplot(d,aes(x=days,ymin=min(mobility)-1, y=mobility, ymax=mobility, fill = sa2_type, colour = sa2_type )) +
    scale_color_manual(values = colours) +
    scale_fill_manual(values = colours) +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    scale_y_continuous(limits=c(-100, 110),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
    # scale_x_date(date_breaks = "weeks",expand=c(0,0), date_labels = "%d\n%b") +
    scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat) +
    geom_hline(yintercept = 0, color="white") +
    geom_vline(xintercept = bordersclose, color=dvblack) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvblack) +
    geom_vline(xintercept = lv3start, color=dvblack) +
    geom_vline(xintercept = lv4start, colour = dvblack) +
    geom_vline(xintercept = lv4end, colour = dvblack) +
    geom_vline(xintercept = lv3end, colour = colours[category]) +
    geom_area(alpha=0.1) +
    labs(y="", x="",title=toupper(category))+
    theme_dv_norm
  return(myplot)
}


plotem_category <- function(cat){
  categoryPlot(cat)%>%
    ggsave(file=paste0("outputs/report_", TIMESTAMP,"/mobility-categories/",toFname(cat),"_mobility.svg"), width=200, height=90,units="mm",bg = "transparent")
}


  plotem_category("Retail")
  plotem_category("Recreational")
  plotem_category("Residential")
  plotem_category("Tourism")
  plotem_category("Transit")
  plotem_category("Workplace")
 


################## Plot regional council ----------------------------------
council_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/mobility_council_data.csv"))

getCouncil <- function(council){
  print(paste0(council," Region"))
  d <- council_comparison %>% filter(days > as.Date("2020-03-15")) %>% filter(regc2018_name == council)
  return(d)
}

councilPlot <- function(council){
  d <- getCouncil(council)

  b <- ggplot(d,aes(x=days, y=mobility)) +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat) +
    scale_y_continuous(limits=c(-100, 110),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
    geom_hline(yintercept = 0, color="white") +
    geom_vline(xintercept = bordersclose, color=dvblack) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvblack) +
    geom_vline(xintercept = lv3start, color=dvblack) +
    geom_vline(xintercept = lv4start, colour = dvblack) +
    geom_vline(xintercept = lv4end, colour = dvblack) +
    geom_vline(xintercept = lv3end, colour = mobility_palette[1]) +
    geom_area(fill=mobility_palette[1],  colour=mobility_palette[1],alpha = 0.1) +
    labs(y="", x="",title = "")+
    theme_dv_norm
 
  return(b)
}


plotem_council <- function(cat){
  councilPlot(cat)%>%
    ggsave(file=paste0("outputs/report_", TIMESTAMP,"/mobility-regions/",toFname(cat),"-index.svg"), width=200, height=90,units="mm",bg = "transparent")
}

councils = unique(council_comparison$regc2018_name)

lapply(councils,plotem_council)
