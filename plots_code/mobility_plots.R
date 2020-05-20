mobility_theme <- theme(
  line = element_line(colour = dvblack),
  text = element_text(family = "Poppins", colour = dvblack),
  plot.margin = margin(2, 2, 2, 2, "mm"),
  # panel.border = element_rect(colour = bordergrey, fill=NA, size=0.5), ## adds a grey box around each plot
  panel.spacing = unit(2, "lines"), ## Puts some more distance between each plot
  plot.title = element_text(size= 12, margin=margin(0,0,25,0)),
  axis.line.y = element_blank(),
  axis.line.x = element_line(size=0.3),
  axis.text.x = element_text(size = 6,margin=margin(4,0,0,0),family = "Poppins"),
  axis.text.y = element_text(size = 6,margin=margin(4,3,0,0),family = "Poppins"),
  axis.ticks.y = element_blank(),
  axis.ticks.x = element_line(colour = dvblack, size = 0.3),
  axis.ticks.length.x = unit(1,units="mm"),
  panel.grid = element_blank(),
  panel.grid.major.y = element_line(size = 0.3,colour =bordergrey),
  strip.background = element_blank(),
  plot.background = element_rect(colour = bordergrey, fill=NA, size=0.3),
  # plot.background = element_blank(),
  legend.position="none"
)

dvblack <-"#172B4D"
dvgrey <- "#8B95A6"
bordergrey <-"#DADCE0"

mobility_palette <- c(
  `orange` = "#EC927D",
  `light-orange` = "#FBE9E5"
)

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

bordersclose = ymd("2020-03-19")
lv2start = ymd("2020-03-21")
lv3start = ymd("2020-03-23")
lv4start = ymd("2020-03-25")
lv4end = ymd("2020-04-28")
lv3end = ymd("2020-05-14")

################## Plot categories ----------------------------------
category_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/mobility_category_data.csv"))

getCategory <- function(category){
  d <- category_comparison %>% filter(days > as.Date("2020-03-15")) %>% filter(sa2_type == category)
  return(d)
}

xdateformat <- function(d){
  toupper(format(d,"%d\n%b"))
}

categoryPlot <- function(category){
  d <- getCategory(category)
  
  myplot <- ggplot(d,aes(x=days,ymin=min(mobility)-1, y=mobility, ymax=mobility, fill = sa2_type, colour = sa2_type )) +
    scale_color_manual(values = colours) +
    scale_fill_manual(values = fillcolours) +
    geom_area() +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    scale_y_continuous(limits=c(-100, 110),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
    # scale_x_date(date_breaks = "weeks",expand=c(0,0), date_labels = "%d\n%b") +
    scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat) +
    geom_vline(xintercept = bordersclose, color=dvgrey) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvgrey) +
    geom_vline(xintercept = lv3start, color=dvgrey) +
    geom_vline(xintercept = lv4start, colour = dvgrey) +
    geom_vline(xintercept = lv4end, colour = dvgrey) +
    geom_vline(xintercept = lv3end, colour = colours[category]) +
    labs(y="", x="",title=toupper(category))+
    mobility_theme
  
  return(myplot)
}

p1 <- plot_grid(
  categoryPlot("Retail"),
  categoryPlot("Recreational"),
  categoryPlot("Residential"),
  categoryPlot("Tourism"),
  categoryPlot("Transit"),
  categoryPlot("Workplace"),
  ncol=2,
  scale = 0.90
)
p1

ggsave(p1, file=paste0("outputs/report_", TIMESTAMP, "/mobility_category_plot.svg"), units = "mm", width=170, height=175) 

################## Plot regional council ----------------------------------
council_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/mobility_council_data.csv"))

getCouncil <- function(council){
  print(paste0(council," Region"))
  d <- council_comparison %>% filter(days > as.Date("2020-03-15")) %>% filter(regc2018_name == paste0(council," Region"))
  return(d)
}

councilPlot <- function(council){
  d <- getCouncil(council)

  b <- ggplot(d,aes(x=days, y=mobility)) +
    geom_area(fill=mobility_palette[2],  colour=mobility_palette[1]) +
    theme_void() + ## theme_X has some default themes and void is the one that strips everything
    scale_x_date(date_breaks = "weeks",expand=c(0,0), labels = xdateformat) +
    scale_y_continuous(limits=c(-100, 110),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
    geom_vline(xintercept = bordersclose, color=dvgrey) + # The vertical lines....
    geom_vline(xintercept = lv2start, color=dvgrey) +
    geom_vline(xintercept = lv3start, color=dvgrey) +
    geom_vline(xintercept = lv4start, colour = dvgrey) +
    geom_vline(xintercept = lv4end, colour = dvgrey) +
    geom_vline(xintercept = lv3end, colour = mobility_palette[1]) +
    labs(y="", x="",title=toupper(council))+
    mobility_theme
    # 
  return(b)
}

council_1 <- plot_grid(
  councilPlot("Northland"),
  councilPlot("Auckland"),
  councilPlot("Waikato"),
  councilPlot("Bay of Plenty"),
  councilPlot("Gisborne"),
  councilPlot("Hawke's Bay"),
  ncol=2,
  scale = 0.95
)

ggsave(council_1, file=paste0("outputs/report_", TIMESTAMP, "/mobility_council_plot_1.svg"),width=170, height=175,units="mm")

council_2<- plot_grid(
  councilPlot("Taranaki"),
  councilPlot("Manawatu-Wanganui"),
  councilPlot("Wellington"),
  councilPlot("West Coast"),
  councilPlot("Canterbury"),
  councilPlot("Otago"),
  ncol=2,
  scale = 0.95
)

ggsave(council_2, file=paste0("outputs/report_", TIMESTAMP, "/mobility_council_plot_2.svg"),width=170, height=175,units="mm")

council_3 <- plot_grid(
  councilPlot("Southland"),
  councilPlot("Tasman"),
  councilPlot("Nelson"),
  councilPlot("Marlborough"),
  ncol=2,
  scale = 0.95
)

ggsave(council_3, file=paste0("outputs/report_", TIMESTAMP, "/mobility_council_plot_3.svg"),width=170, height=117,units="mm")
