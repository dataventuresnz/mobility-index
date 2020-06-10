

dot_pallette = c( "#F7CD96","#EB7D45","#AED6F2")

regOrder=c("Northland",
           "Auckland",
           "Waikato",
           "Bay of Plenty",
           "Gisborne",
           "Hawke's Bay",
           "Taranaki",
           "Manawatu-Wanganui",
           "Wellington",
           "West Coast",
           "Canterbury",
           "Otago",
           "Southland",
           "Tasman",
           "Nelson",
           "Marlborough")

labelPosition <- function(vals){
  pos <-  sapply(vals, function(d) if (d>= 0){p <- d+15} else {p <- d-15})
  return(pos)
}

dat <- read_csv(paste0("outputs/report_",TIMESTAMP,"/data/mobility_weekly_data.csv")) %>%
  filter(comparison == "previous_week") %>%
  mutate(regc2018_name = gsub(" Region", "", regc2018_name),
         regc2018_name = factor(regc2018_name, levels = rev(regOrder)),
         )

lab <-function(i){format(i, nsmall=1,digits=1)}

labelFormat <- function(index){
  newLabel <- sapply(index, function(d) if (d>= 0){p <- paste0("+",lab(d),"%")} else {p <- paste0(lab(d),"%")})
  return(newLabel)
}


dotplot <- ggplot(dat) +
  geom_segment(aes(x=regc2018_name, y=0, xend=regc2018_name, yend=mobility),size=1/2.13, colour= dot_pallette[3])+
  geom_point(aes(x=regc2018_name, y=0, size = 3), colour = dot_pallette[3]) +
  geom_point(aes(x=regc2018_name, y=mobility, size = 3), colour = dot_pallette[2]) +
  geom_text(aes(x=regc2018_name, y=labelPosition(mobility), label = labelFormat(mobility),family = "Poppins"), colour = "white", size = 3.3)+
  scale_y_continuous(limits = c(-100,100),expand=c(0,0)) +
  labs(y="", x="",title="1 WEEK AGO v 2 WEEKS AGO",family = "Poppins")+
  theme_void() +
  dot_theme +
  coord_flip()

dotplot

ggsave(dotplot, file=paste0("outputs/report_", TIMESTAMP, "/mobility-dot-plot/mobility_dot_plot_week.svg"),width=170, height=110,units="mm",bg="transparent")

dat <- read_csv(paste0("outputs/report_",TIMESTAMP,"/data/mobility_weekly_data.csv")) %>%
  filter(comparison == "previous_year") %>%
  mutate(regc2018_name = gsub(" Region", "", regc2018_name),
         regc2018_name = factor(regc2018_name, levels = rev(regOrder)),
  )

dotplot <- ggplot(dat) +
  geom_segment(aes(x=regc2018_name, y=0, xend=regc2018_name, yend=mobility),size=1/2.13, colour= dot_pallette[1])+
  geom_point(aes(x=regc2018_name, y=0, size = 3), colour = dot_pallette[1]) +
  geom_point(aes(x=regc2018_name, y=mobility, size = 3), colour = dot_pallette[2]) +
  geom_text(aes(x=regc2018_name, y=labelPosition(mobility), label = labelFormat(mobility)), family = "Poppins", colour = "white", size = 3.3)+
  scale_y_continuous(limits = c(-100,100),expand=c(0,0)) +
  labs(y="", x="",title="1 WEEK AGO v NORMAL WEEK 2019")+
  theme_void() +
  dot_theme +
  coord_flip()
dotplot

ggsave(dotplot, file=paste0("outputs/report_", TIMESTAMP, "/mobility-dot-plot/mobility_dot_plot_year.svg"),width=170, height=110,units="mm",bg="transparent")


