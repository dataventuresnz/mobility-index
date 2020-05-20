

dot_theme <- theme(
  line = element_line(colour = dvblack),
  text = element_text(family = "Poppins", colour = dvblack),
  plot.margin = margin(2, 2, 2, 2, "mm"),
  # panel.border = element_rect(colour = bordergrey, fill=NA, size=0.5), ## adds a grey box around each plot
  panel.spacing = unit(2, "lines"), ## Puts some more distance between each plot
  plot.title = element_text(size= 16, margin=margin(0,30,0,0)),
  axis.line.y = element_blank(),
  axis.line.x = element_line(),
  axis.text.x = element_text(size = 10, margin=margin(4,0,0,0),family = "Poppins"),
  axis.text.y = element_text(size = 10,margin=margin(4,8,0,0),hjust=1,family = "Poppins"),
  axis.ticks.y = element_blank(),
  axis.ticks.x = element_line(colour = dvblack ,size = 0.5),
  axis.ticks.length.x = unit(1,units="mm"),
  panel.grid = element_blank(),
  panel.grid.major.y = element_line(size = 0.2,colour = bordergrey),
  strip.background = element_blank(),
  plot.background = element_rect(colour = bordergrey, fill=NA, size=0.5),
  # plot.background = element_blank(),
  legend.position="none"
)

dvblack <-"#172B4D"
dvgrey <- "#8B95A6"
bordergrey <-"#DADCE0"

dot_pallette = c( "#F7CD96","#EB7D45","#AED6F2")

regOrder=c("Northland Region",
           "Auckland Region",
           "Waikato Region",
           "Bay of Plenty Region",
           "Gisborne Region",
           "Hawke's Bay Region",
           "Taranaki Region",
           "Manawatu-Wanganui Region",
           "Wellington Region",
           "West Coast Region",
           "Canterbury Region",
           "Otago Region",
           "Southland Region",
           "Tasman Region",
           "Nelson Region",
           "Marlborough Region")

dat <- read_csv(paste0("outputs/report_",TIMESTAMP,"/mobility_weekly_data.csv")) %>%
  filter(comparison == "previous_week") %>%
  mutate(regc2018_name = factor(regc2018_name, levels = rev(regOrder)))

dotplot <- ggplot(dat) +
  geom_segment(aes(x=regc2018_name, y=0, xend=regc2018_name, yend=mobility),size=1.5, colour= dot_pallette[3])+
  geom_point(aes(x=regc2018_name, y=0, size = 3), colour = dot_pallette[3]) +
  geom_point(aes(x=regc2018_name, y=mobility, size = 3), colour = dot_pallette[2]) +
  geom_text(aes(x=regc2018_name, y=mobility, label = paste0(mobility,"%"),family = "Poppins"), colour = dvblack, size = 3.3 , nudge_y = 15)+
  scale_y_continuous(limits = c(-100,100),expand=c(0,0)) +
  labs(y="", x="",title="1 WEEK AGO v 2 WEEKS AGO",family = "Poppins")+
  theme_void() +
  dot_theme +
  coord_flip()

dotplot

ggsave(dotplot, file=paste0("outputs/report_", TIMESTAMP, "/mobility_dot_plot_week.svg"),width=170, height=110,units="mm")

dat <- read_csv(paste0("outputs/report_",TIMESTAMP,"/mobility_weekly_data.csv")) %>%
  filter(comparison == "previous_year") %>%
  mutate(regc2018_name = factor(regc2018_name, levels = rev(regOrder)))

dotplot <- ggplot(dat) +
  geom_segment(aes(x=regc2018_name, y=0, xend=regc2018_name, yend=mobility),size=1.5, colour= dot_pallette[1])+
  geom_point(aes(x=regc2018_name, y=0, size = 3), colour = dot_pallette[1]) +
  geom_point(aes(x=regc2018_name, y=mobility, size = 3), colour = dot_pallette[2]) +
  geom_text(aes(x=regc2018_name, y=mobility, label = paste0(mobility,"%")), family = "Poppins", colour = dvblack, size = 3.3 , nudge_y = -15)+
  scale_y_continuous(limits = c(-100,100),expand=c(0,0)) +
  labs(y="", x="",title="1 WEEK AGO v NORMAL WEEK 2019")+
  theme_void() +
  dot_theme +
  coord_flip()
dotplot

ggsave(dotplot, file=paste0("outputs/report_", TIMESTAMP, "/mobility_dot_plot_year.svg"),width=170, height=110,units="mm")


