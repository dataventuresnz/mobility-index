
#################### This scrit sets up some environment variables, creates the data, then makes plots ####################
#################### The plots can be made using the published data in outputs under each report ####################

library(data.table)
library(tidyverse)
library(dtplyr)
library(ventuRes)
library(lubridate)
library(RPostgreSQL)
library(cowplot)
library(extrafont)
library(showtext)

source("functions.R")


## Showtext turns fonts into paths in svg plots. You will need to initially add fonts you want to use, once only using sysfonts::font_add()
## This turns showtext on for the whole session.
## https://cran.r-project.org/web/packages/showtext/showtext.pdf
sysfonts::font_add_google(name="Poppins")
showtext_auto(enable=TRUE)

## Variables
db = Sys.getenv("PGS.DB.PROD")

#Folder suffix
TIMESTAMP <- "20200614"


subfolders = c(
  "before-now",
  "mobility-categories",
  "mobility-dot-plot",
  "mobility-regions",
  "national-overview",
  "sparklines"
)

dir.create(file.path(getwd(), paste0("outputs/report_", TIMESTAMP)), showWarnings = FALSE)

for (folder in subfolders){
  dir.create(file.path(getwd(), paste0("outputs/report_", TIMESTAMP,"/",folder)), showWarnings = FALSE)
}

dir.create(file.path(getwd(), paste0("outputs/data_", TIMESTAMP)), showWarnings = FALSE)

#Set end of week period
epoch <- 13
period_end <- floor_date(Sys.Date(), "week")

period_start <- period_end - days(epoch)

#End of week
eow <- wday(period_end)

#######################################          levels

bordersclose = ymd("2020-03-19")
lv2start = ymd("2020-03-21")
lv3start = ymd("2020-03-23")
lv4start = ymd("2020-03-25")
lv4end = ymd("2020-04-28")
lv3end = ymd("2020-05-14")
lv2end = ymd("2020-06-09")

past_levels = c(bordersclose,
                lv2start,
                lv3start,
                lv4start,
                lv4end,
                lv3end)

past_levels=tibble(past_levels)

current_level = lv2end

########################################## Make data ----------------------

# Public dont have to run or know about this to make the plots
source("make_output_data.R")

########################################## Make plots ----------------------
source("ourThemes.R")

source("plots/sparkline_plots.R")

source("plots/week_plots.R")

source("plots/mobility_plots.R")

source("plots/mobility_dots.R")

source("plots/national_plots.R")
