#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# This is script loads packages used for dev of target objects.
#
# By: mike gaunt, michael.gaunt@wsp.com
#
# README: [[insert brief readme here]]
#-------- [[insert brief readme here]]
#
# *please use 80 character margins
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#library set-up=================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#content in this section should be removed if in production - ok for dev
library(gauntlet)
library(here)

pkgs = c("tibble", "tidyverse", "gauntlet", "lubridate", "data.table"
         ,"here", "DBI", "odbc", "googledrive", "googlesheets4"
         ,"plotly", "crosstalk", "kableExtra", "reactable", "lubridate"
         ,"roll")

package_load(pkgs)

#import data====================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#manual step to send/receive data from Google drive location
#this is ran on mikes local computer



#helpful targets functions======================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#manual step to send/receive data from Google drive location

#script end=====================================================================




library(bosFunctions)


bosFunctions::rct

bosFunctions::table_accts_cycleDay()

































