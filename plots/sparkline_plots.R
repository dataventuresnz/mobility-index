
# Pull telco data
dat <- read_csv(paste0("outputs/data_", TIMESTAMP, "/sparkline_data.csv"))

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
    geom_vline(data=past_levels, aes(xintercept = as_datetime(past_levels)), colour = dvblack) + # The vertical lines....
    geom_vline(xintercept = as_datetime(current_level), colour = colours[segment]) +
    geom_ribbon(outline.type = "upper",alpha=0.1) + ## Add a ribbon which fills under the line with low opacity
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

