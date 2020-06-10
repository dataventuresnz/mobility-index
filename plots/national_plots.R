bordersclose = ymd_hms("2020-03-19T00:00:00")
lv2start = ymd_hms("2020-03-21T00:00:00")
lv3start = ymd_hms("2020-03-23T00:00:00")
lv4start = ymd_hms("2020-03-25T00:00:00")
lv4end = ymd_hms("2020-04-28T00:00:00")
lv3end = ymd_hms("2020-05-14T00:00:00")

# Pull telco data
dat_counts <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/national_data.csv")) %>%
  filter(segment %in% c("domestic", "international")) %>%
  mutate(timestamp = as.Date(timestamp))

dat_mobility <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/mobility_national_data.csv")) %>%
  mutate(days = as.Date(days))

mobility_palette <- c(
  `orange` = "#EC927D",
  `light-orange` = "#FBE9E5"
)

xdateformat <- function(dat_counts){
  toupper(format(dat_counts,"%d\n%b"))
}

dom_counts <- dat_counts %>% filter(segment=="domestic") %>% 
  ggplot( aes(x=timestamp,ymin=0, ymax=pop, y=pop)) +
  scale_y_continuous(expand = c(0,0), limits=c(0, 550000), label = scales::unit_format(unit = "k",scale = 1e-3,sep="")) +
  scale_x_date(date_breaks = "2 weeks",expand=c(0,0), labels = xdateformat, limits = c(as.Date("2020-03-16"), as.Date(period_end + weeks(1)))) +
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  geom_vline(xintercept = bordersclose, color=dvblack, size=2/2.13) + # The vertical lines....
  geom_vline(xintercept = as.Date(lv2start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4start), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4end), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3end), colour = "#F0C47F", size=2/2.13) +
  geom_line(color= "#F0C47F", size=2/2.13)+
  labs(y="", x="") +
  theme_dv_norm +
  theme(axis.text.x = element_text(colour=dvblack,size=8),axis.text.y = element_text(colour=dvblack,size=8))
  

ggsave(dom_counts, file=paste0("outputs/report_", TIMESTAMP,"/national-overview/domestic-population.svg"), width=100, height=72,units="mm",bg = "transparent")

int_counts <-dat_counts %>% filter(segment=="international") %>% 
  ggplot( aes(x=timestamp,ymin=0, ymax=pop, y=pop)) +
  scale_y_continuous(expand = c(0,0), limits=c(0, 520000),label = scales::unit_format(unit = "k",scale = 1e-3,sep="")) +
  scale_x_date(date_breaks = "2 weeks",expand=c(0,0), labels = xdateformat, limits = c(as.Date("2020-03-16"), as.Date(period_end + weeks(1)))) +
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  geom_vline(xintercept = bordersclose, color=dvblack, size=2/2.13) + # The vertical lines....
  geom_vline(xintercept = as.Date(lv2start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4start), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4end), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3end), colour = "#1EAE9B", size=2/2.13) +
  geom_line(color= "#1EAE9B", size=2/2.13)+
  labs(y="", x="") +
  theme_dv_norm + 
  theme(axis.text.x = element_text(colour=dvblack,size=8),axis.text.y = element_text(colour=dvblack,size=8))
 

ggsave(int_counts, file=paste0("outputs/report_", TIMESTAMP,"/national-overview/international-population.svg"), width=100, height=72,units="mm",bg = "transparent")

mobility <- ggplot(dat_mobility,aes(x=days, y=mobility)) +
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  scale_x_date(date_breaks = "2 weeks",expand=c(0,0), labels = xdateformat, limits = c(as.Date("2020-03-16"), as.Date(period_end + weeks(1)))) +
  scale_y_continuous(limits=c(-100, 100),expand=c(0,0)) + ## Set the same y-axis which squishes things down and makes room for text labels
  geom_vline(xintercept = bordersclose, color=dvblack, size=2/2.13) + # The vertical lines....
  geom_vline(xintercept = as.Date(lv2start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3start), color=dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4start), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv4end), colour = dvblack, size=2/2.13) +
  geom_vline(xintercept = as.Date(lv3end), colour = mobility_palette[1], size=2/2.13) +
  geom_area(color="#EC927D", fill="#EC927D",alpha=0.1, size=2/2.13)+
  labs(y="", x="") +
  theme_dv_norm +
  theme(plot.margin = margin(5,15,0,0, unit="pt"))

ggsave(mobility, file=paste0("outputs/report_", TIMESTAMP,"/national-overview/national-mobility.svg"), width=400, height=150,units="mm",bg = "transparent")
