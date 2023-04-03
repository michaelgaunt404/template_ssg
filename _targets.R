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
  tar_target(
    name = data,
    command = tibble(x = rnorm(100), y = rnorm(100))
    #   format = "feather" # efficient storage of large data frames # nolint
  )
  ,tar_target(
    name = model,
    command = coefficients(lm(y ~ x, data = data))
  )
  ,tar_render(temp_analysis, "analysis/temp_analysis.rmd")
  #icrs report==================================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##data processing====
  ,tar_target(file_icrs, here("data", "icrs_data.csv"), format = "file")
  ,tar_target(data_icrs_raw, make_icrs_mult(file_icrs))
  ,tar_target(data_icrs, make_icrs_most_recent(data_icrs_raw, query_date = NULL))
  ,tar_target(data_icrs_prev, make_icrs_previous(data_icrs_raw))
  # ,tar_target(data_icrs_prev_month, make_icrs_prev_month(data_icrs, data_icrs_prev, "week"))
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
  #daily_reporting_objects======================================================
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ##trip_posting_summary====
  ,tar_target(file_trip_posting_summary
              ,here("data", "data_trip_posting_summary.csv"), format = "file")
  ,tar_target(data_trp_pstng_smmry_by_pstngdt
              ,process_trp_pstng_smmry_by_pstngdt(file_trip_posting_summary))
  ,tar_target(tble_objct_trp_pstng_smmry_by_pstngdt
              ,table_trp_pstng_smmry_by_pstngdt(
                data = data_trp_pstng_smmry_by_pstngdt
                ,id = "data_trp_pstng_smmry_by_pstngdt"))
  ,tar_target(data_trp_pstng_smmry_by_trpdt
              ,process_trp_pstng_smmry_by_trpdt(file_trip_posting_summary))
  ,tar_target(tble_objct_trp_pstng_smmry_by_trpdt
              ,table_trp_pstng_smmry_by_trpdt(
                data = data_trp_pstng_smmry_by_trpdt
                ,id = "data_trp_pstng_smmry_by_trpdt"))
  ##pass_fulfillment====
  ,tar_target(file_pass_fulfillment
              ,here("data", "data_pass_fulfillment.csv"), format = "file")
  ,tar_target(data_pass_fulfillment
              ,process_pss_flfllmnt(file_pass_fulfillment))
  ,tar_target(tble_pass_fulfillment
              ,table_pss_flfllmnt(
                data = data_pass_fulfillment
                ,id = "data_pass_fulfillment"))
  ##pass_fulfillment====
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
  ##end====
)
