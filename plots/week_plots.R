

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

week_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/week_comparison_data.csv")) %>%
  filter(measure != "baseline_year")%>%
  mutate(measure=unname(sapply(measure,changelabels)))

year_comparison <- read_csv(paste0("outputs/report_", TIMESTAMP, "/data/week_comparison_data.csv")) %>%
  filter(measure != "baseline_week")%>%
  mutate(measure=unname(sapply(measure,changelabels)))

################# Plot things up
# night = seq(42,170,24) #6pm each day
# night =  tibble(night)
day = seq(30,191,24) #6am each day
day =  tibble(day)

night_colour = "#8B95A6"
day_colour = "#C5CAD2"

labels <- week_comparison %>% filter(hour(timestamp) == 12) %>% select(day, hour) %>% distinct()

duo_plot <- function(dat1, dat2, type, baseline="#8B95A6", category,category_fill) {
  # Get min/max and each dataset to get limits on axes
  limits <- c(
    min(min(filter(dat1, sa2_type == type)$pop_scaled), min(filter(dat2, sa2_type == type)$pop_scaled)),
    max(max(filter(dat1, sa2_type == type)$pop_scaled), max(filter(dat2, sa2_type == type)$pop_scaled))
    )
  
  daybar_width <- 0.03*(limits[2]-limits[1])
  daybar_top <- limits[1]-2*daybar_width
  limits[1] = limits[1]-3*daybar_width # we have to add a bit of margin by hand, as we have circumvented "extend"
  limits[2] = limits[2]+2*daybar_width
  
  dat1 <- dat1 %>% filter(sa2_type == type)
  dat2 <- dat2 %>% filter(sa2_type == type)
  weekend <- dat2 %>% filter(day=="Sat"|day=="Sun") %>% summarise(xmin=min(hour),xmax=max(hour))
  
  lastyearplot <<- ggplot(dat2) +
      scale_color_manual(values=c(`NORMAL WEEK 2019`=baseline, `1 WEEK AGO`=category)) +
      geom_rect(data =weekend , aes(xmin=xmin, xmax=xmax, ymin=-Inf,ymax=Inf), colour = NA, fill = category, alpha = 0.05)+
      geom_rect(xmin=min(dat2$hour), xmax=max(dat2$hour), ymin=-Inf,ymax=daybar_top, colour = NA, fill = night_colour)+
      geom_rect(data =day , aes(xmin=day, xmax=day+12, ymin=-Inf,ymax=daybar_top), colour = NA, fill = day_colour)+
      geom_hline(yintercept=daybar_top, colour = night_colour)+
       geom_line(aes(x=hour, y=pop_scaled, group=measure, color=measure),size=1.5/2.13) +
       theme_dv_lines +
       scale_y_continuous(limits = limits,expand = c(0,0)) +
       scale_x_continuous(breaks=labels$hour,
                          labels=toupper(labels$day),
                          expand = c(0,0)) +
       labs(y="", x="", title = "1 WEEK AGO v NORMAL WEEK 2019")+
       weekplot_theme
                     
  lastweekplot <<- ggplot(dat1) +
                        geom_rect(data =weekend , aes(xmin=xmin, xmax=xmax, ymin=-Inf,ymax=Inf), colour = NA, fill = category, alpha = 0.05)+
                        geom_rect(xmin=min(dat1$hour), xmax=max(dat1$hour), ymin=-Inf,ymax=daybar_top, colour = NA, fill = night_colour)+
                        geom_rect(data =day , aes(xmin=day, xmax=day+12, ymin=-Inf,ymax=daybar_top), colour = NA, fill = day_colour)+
                        geom_hline(yintercept=daybar_top, colour = night_colour)+
                       geom_line(aes(x=hour, y=pop_scaled, group=measure, color=measure),size = 1.5/2.13) +
                       theme_dv_lines +
                       scale_y_continuous(limits = limits,expand = c(0,0)) +
                       scale_color_manual(values=c(`2 WEEKS AGO`=baseline, `1 WEEK AGO`=category)) +
                       scale_x_continuous(breaks=labels$hour,
                                          labels=toupper(labels$day),
                                          expand = c(0,0)) +
                       labs(y="", x="", title = "1 WEEK AGO v 2 WEEKS AGO")+
                       weekplot_theme
                      
  
}

categories = c("Recreational","Retail","Tourism", "Workplace","Residential","Transit")


for (cat in categories){
  duo_plot(week_comparison, year_comparison, cat, category=unname(colours[cat]),category_fill=unname(fillcolours[cat]))
  
  ggsave(lastweekplot,file=paste0("outputs/report_", TIMESTAMP,"/before-now/",toFname(cat),"-last-week.svg"), width=200, height=112,units="mm",bg = "transparent")
  ggsave(lastyearplot,file=paste0("outputs/report_", TIMESTAMP,"/before-now/",toFname(cat),"-last-year.svg"), width=200, height=112,units="mm",bg = "transparent")
}

