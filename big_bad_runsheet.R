
#################### This scrit sets up some environment variables, creates the data, then makes plots ####################
#################### The plots can be made using the published data in outputs under each report ####################

library(data.table)
library(tidyverse)
library(dtplyr)
library(ventuRes)
library(lubridate)
library(RPostgreSQL)
library(cowplot)

source("functions.R")

## Variables

#Folder suffix
TIMESTAMP <- "20200427"

dir.create(file.path(getwd(), paste0("outputs/report_", TIMESTAMP)), showWarnings = FALSE)

#Set end of week period
epoch <- 13
#period_end <- floor_date(Sys.Date(), "week")
period_end <- as.Date("2020-04-27")

period_start <- period_end - days(epoch)

#End of week
eow <- wday(period_end)

########################################## Make data ----------------------

# Public dont have to run or know about this to make the plots
source("make_output_data.R")

########################################## Make plots ----------------------

source("plots/sparkline_plots.R")

source("plots/week_plots.R")

source("plots/mobility_plots.R")
