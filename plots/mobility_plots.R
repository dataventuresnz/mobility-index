

category_comparison <- read_csv(paste0("outputs/data_", TIMESTAMP, "/mobility_category_data.csv"))

getCategory <- function(category){
  d <- category_comparison %>% filter(days > as.Date("2020-03-15")) %>% filter(sa2_type == category)
  return(d)
}


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
    geom_vline(data=past_levels, aes(xintercept = past_levels), colour = dvblack) + # The vertical lines....
    geom_vline(xintercept = current_level, colour = colours[category]) +
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
council_comparison <- read_csv(paste0("outputs/data_", TIMESTAMP, "/mobility_council_data.csv"))

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
    geom_vline(data=past_levels, aes(xintercept = past_levels), colour = dvblack) + # The vertical lines....
    geom_vline(xintercept = current_level, colour = mobility_palette[1]) +
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
