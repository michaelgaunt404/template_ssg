#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# This is script perfroms ETAN queries and inital data processing
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

pkgs = c("tibble", "tidyverse", "lubridate", "data.table", 'bosFunctions'
         ,"here", "DBI", "odbc", "googledrive", "googlesheets4")

package_load(pkgs)

#path set-up====================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#content in this section should be removed if in production - ok for dev
# db_conn = dbConnect(odbc(), "etan_listener_20220628")

#source helpers/utilities=======================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#content in this section should be removed if in production - ok for dev
# source(here("R/functions_query_database.r"))
get_gdrive_file_safe = safely(get_gdrive_file)

#source data====================================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#content in this section should be removed if in production - ok for dev
#area to upload data with and to perform initial munging
#please add test data here so that others may use/unit test these scripts

#Downloading data to CPU========================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
message("Starting downloading data from GDrive storage")

c("data_image_dl_queue", "icrs_data", "data_pass_fulfillment", "data_trip_posting_summary"
  ,"data_account_creation", "data_posting_performance", "data_acct_cycle_day_summary", "data_csr_closure_summary"
  ,"data_disposition_summary", "escalation_counts_by_trip_date", "nocp_counts_by_trip_date") %>%
  map(~{
    message(str_glue("Fetching **{.x}** from gdrive"))
    get_gdrive_file_safe(.x)
  })

message("Finished downloading objects....")

gauntlet::alert_me()


