# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tibble", "tidyverse", "lubridate", "data.table"
               ,"here", "DBI", "odbc", "googledrive", "googlesheets4", "here"
               ,"gauntlet", 'bosFunctions'
               ,"plotly", "crosstalk", "kableExtra"
               ,"roll", "reactable", "htmltools"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multiprocess")

# tar_make_future() configuration (okay to leave alone):
future::plan(future.callr::callr)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  #image_download_queue report==================================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##data processing====
  tar_target(file_imgdlq, here("data", "data_image_dl_queue.csv"), format = "file")
  ,tar_target(file_index_imgdl_queue_tllsts, here("data", "index_imgdl_queue_tllsts.csv"), format = "file")
  ,tar_target(file_index_imgdl_queue_rdsd, here("data", "index_imgdl_queue_rdsd.csv"), format = "file")
  ,tar_target(data_imgdlq, make_image_dl_queue(
    file_imgdlq
    ,file_index_imgdl_queue_tllsts
    ,file_index_imgdl_queue_rdsd))
  ,tar_target(data_imgdlq_crrnt, make_imgdlq_crrnt(data_imgdlq))
  ,tar_target(data_imgdlq_agg, make_imgdlq_agg(data_imgdlq))
  ,tar_target(data_tollsts_ts_rdwy
              ,make_tollsts_ts(data_imgdlq
                               ,grp_agg = c("queried_at", "roadway", "rdsd_desc", "tsc_desc")
                               ,grp_lag = c("roadway", "rdsd_desc", "tsc_desc")))
  ,tar_target(data_tollsts_ts
              ,make_tollsts_ts(data_imgdlq
                               ,grp_agg = c("queried_at", "rdsd_desc", "tsc_desc")
                               ,grp_lag = c("rdsd_desc", "tsc_desc")))
  ,tar_target(data_agg_data_ts, make_agg_data_ts(data_imgdlq))
  #icrs report==================================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##data processing====
  ,tar_target(file_icrs, here("data", "icrs_data.csv"), format = "file")
  ,tar_target(data_icrs_raw, make_icrs_mult(file_icrs))
  ,tar_target(data_icrs, make_icrs_most_recent(data_icrs_raw, query_date = NULL))
  ,tar_target(data_icrs_prev, make_icrs_previous(data_icrs_raw))
  ,tar_target(data_icrs_prev_month, make_icrs_prev_month(data_icrs, data_icrs_prev, "week"))
  ,tar_target(data_mult_unident_agg, make_mult_unident_agg(data_icrs_raw))
  ,tar_target(data_icrs_aggShort, make_icrs_aggShort(data_icrs))
  ,tar_target(data_icrs_aggShort_stats, make_icrs_aggShort_stats(data_icrs_aggShort))
  ,tar_target(data_icrs_aggShort_strat, make_icrs_aggShort_strat(data_icrs_aggShort))
  ,tar_target(data_icrs_aggShort_stats_result, make_icrs_aggShort_stats_result(data_icrs))
  #just for MIR====
  ,tar_target(data_icrs_aggShort_MIR, make_icrs_aggShort(data_icrs %>% filter(ir_result == "2-MIR")))
  ,tar_target(data_icrs_aggShort_stats_MIR, make_icrs_aggShort_stats(data_icrs_aggShort_MIR))
  ,tar_target(data_icrs_aggShort_strat_MIR, make_icrs_aggShort_strat(data_icrs_aggShort_MIR))
  ,tar_target(data_icrs_aggShort_stats_result_MIR, make_icrs_aggShort_stats_result(data_icrs %>% filter(ir_result == "2-MIR")))
  ,tar_target(pltobject_qfree_ident_plats_vendor_MIR, plot_qfree_ident_plats_vendor(data_icrs_aggShort_stats_MIR))
  ,tar_target(pltobject_qfree_ident_plats_vendor_cumm_MIR, plot_qfree_ident_plats_vendor_cumm(data_icrs_aggShort_stats_MIR))
  ,tar_target(pltobject_qfree_ident_plats_type_MIR, plot_qfree_ident_plats_type(data_icrs_aggShort_stats_result_MIR))
  ##creating plots====
  ###overview_plots====
  ,tar_target(pltobject_overview_unident_agg, plot_overview_unident_agg(data_mult_unident_agg))
  ,tar_target(pltobject_cum_unident_by_mon, plot_cum_unident_by_mon(data_icrs_raw))
  ,tar_target(pltobject_counts_id_unident_week, plot_counts_id_unident(data_icrs, data_icrs_prev, "week"))
  ,tar_target(pltobject_counts_id_unident_day, plot_counts_id_unident(data_icrs, data_icrs_prev, "day"))
  ,tar_target(pltobject_overview_2week, plot_overview_2week(data_icrs, data_icrs_prev))
  ##qfree plots====
  ,tar_target(pltobject_qfree_output_daily, plot_qfree_output_daily(data_icrs))
  ,tar_target(pltobject_qfree_output_comp_date, plot_qfree_output_comp_date(data_icrs))
  ,tar_target(pltobject_qfree_output_comp_date_rdwy, plot_qfree_output_comp_date_rdwy(data_icrs))
  ###days to identify====
  ,tar_target(pltobject_qfree_ident_plats_vendor, plot_qfree_ident_plats_vendor(data_icrs_aggShort_stats))
  ,tar_target(pltobject_qfree_ident_plats_vendor_cumm, plot_qfree_ident_plats_vendor_cumm(data_icrs_aggShort_stats))
  ,tar_target(pltobject_qfree_ident_plats_type, plot_qfree_ident_plats_type(data_icrs_aggShort_stats_result))
  ,tar_target(pltobject_qfree_ident_plats_rdwy, plot_qfree_ident_plats_rdwy(data_icrs))
  ,tar_target(pltobject_qfree_ident_plats_dur, plot_qfree_ident_plats_dur(data_icrs_aggShort_strat))
  ##trip matrix====
  ,tar_target(pltobject_qfree_trip_matrice_fullpro, plot_qfree_trip_matrice_fullpro(data_icrs))
  ,tar_target(pltobject_qfree_trip_matrice_preQfree, plot_qfree_trip_matrice_preQfree(data_icrs))
  ##Plate Identification Result====
  ,tar_target(pltobject_qfree_pir_status, plot_qfree_pir_status(data_icrs))
  ,tar_target(pltobject_qfree_pir_method, plot_qfree_pir_method(data_icrs))
  #escalation===================================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ,tar_target(file_escalation, here("data", "escalation_counts_by_trip_date.csv"), format = "file")
  ,tar_target(data_escalation, fread(file_escalation))
  #daily_reporting_objects======================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##trip_posting_summary====
  ,tar_target(file_trip_posting_summary
              ,here("data", "data_trip_posting_summary.csv"), format = "file")
  # ,tar_target(data_trp_pstng_smmry_by_pstngdt
  #             ,process_trp_pstng_smmry_by_pstngdt(file_trip_posting_summary))
  ,tar_target(tble_objct_trp_pstng_smmry_by_pstngdt
              ,table_trp_pstng_smmry_by_pstngdt(
                file = file_trip_posting_summary
                ,id = "data_trp_pstng_smmry_by_pstngdt"))
  # ,tar_target(data_trp_pstng_smmry_by_trpdt
  #             ,process_trp_pstng_smmry_by_trpdt(file_trip_posting_summary))
  ,tar_target(tble_objct_trp_pstng_smmry_by_trpdt
              ,table_trp_pstng_smmry_by_trpdt(
                file = file_trip_posting_summary
                ,id = "data_trp_pstng_smmry_by_trpdt"))
  ##pass_fulfillment====
  ,tar_target(file_pass_fulfillment
              ,here("data", "data_pass_fulfillment.csv"), format = "file")
  # ,tar_target(data_pass_fulfillment
  #             ,process_pss_flfllmnt(file_pass_fulfillment))
  ,tar_target(tble_pass_fulfillment
              ,table_pss_flfllmnt(
                file = file_pass_fulfillment
                ,id = "data_pass_fulfillment"))
  ##acct_cycle====
  ,tar_target(file_acct_cycle_day_smmry
              ,here("data", "data_acct_cycle_day_summary.csv"), format = "file")
  ,tar_target(
    tble_accts_cycleDay
    ,table_accts_cycleDay(
      file = file_acct_cycle_day_smmry
      ,id = "data_accts_cycleDay"))
  ,tar_target(
    tble_accts_cycleDay_wd
    ,table_accts_cycleDay_wd(
      file = file_acct_cycle_day_smmry
      ,id = "data_accts_cycleDay_wd"))
  ##acct_type====
  ,tar_target(file_acct_type
              ,here("data", "data_account_creation.csv"), format = "file")
  ,tar_target(
    tble_accts_type
    ,table_accts_type(
      file = file_acct_type
      ,id = "data_acct_type"))
  ,tar_target(
    tble_accts_type_wd
    ,table_accts_type_wd(
      file = file_acct_type
      ,id = "data_acct_type_wd"))

  ##end====
)
