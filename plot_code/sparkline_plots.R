library(tidyverse)
library(ventuRes)
library(lubridate)

source("functions.R")

# Pull telco data
dat <- read_csv(paste0("outputs/report_", TIMESTAMP, "/sparkline_data.csv"))
  

# Create plot
## Aggregate pop segments
sparkline_plot <- dat %>%
  ## Base plot
  ggplot(aes(x=timestamp, y=pop_scaled)) +
  scale_color_dv(palette = "category", name = "sa2_type") + ## Changing pallets for the fill
  scale_fill_dv(palette = "category_light", name = "sa2_type") + ## Changing pallets for the color/stroke
  geom_ribbon(aes(ymin=min(pop_scaled), ymax=pop_scaled, fill=sa2_type)) + ## Add a ribbon which fills under the line with low opacity
  geom_line(size=1, aes(color=sa2_type)) + ## Add a line of size 1 with a different color for each place
  facet_wrap(~sa2_type, ncol = 2, scales="free") + ## Create a separate plot for each place
  theme_void() + ## theme_X has some default themes and void is the one that strips everything
  scale_y_continuous(limits=c(NA, 8)) + ## Set the same y-axis which squishes things down and makes room for text labels
  geom_vline(xintercept = as_datetime("2020-03-19 23:59:00"), color="red") + # The vertical lines....
  geom_vline(xintercept = as_datetime("2020-03-21 23:59:00"), color="grey") +
  geom_vline(xintercept = as_datetime("2020-03-23 23:59:00"), color="grey") +
  geom_vline(xintercept = as_datetime("2020-03-25 23:59:00"), color="grey") +
  theme(panel.border = element_rect(colour = "grey", fill=NA, size=0.5), ## adds a grey box around each plot
        panel.spacing = unit(1, "lines"), ## Puts some more distance between each plot
        legend.position="none" ## Removes legend
        )

ggsave(sparkline_plot, file=paste0("outputs/report_", TIMESTAMP, "/sparkline_plot.svg"), width=10, height=8)
