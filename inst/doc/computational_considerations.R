## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = ""
)
library(amadeus)

live_run <- local({
  force <- tolower(Sys.getenv("AMADEUS_RUN_VIGNETTES", "")) %in%
    c("1", "true", "yes")
  on_ci <- nzchar(Sys.getenv("CI")) ||
    nzchar(Sys.getenv("GITHUB_ACTIONS")) ||
    identical(tolower(Sys.getenv("IN_PKGDOWN", "")), "true")
  on_cran <- nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")) ||
    identical(tolower(Sys.getenv("NOT_CRAN", "")), "false")
  force || !(on_ci || on_cran)
})

## ----purrr-baseline, eval = FALSE---------------------------------------------
# if (requireNamespace("purrr", quietly = TRUE)) {
#   library(purrr)
# 
#   dates <- seq.Date(
#     as.Date("2022-01-01"),
#     as.Date("2022-01-05"),
#     by = "day"
#   )
# 
#   results <- purrr::map(dates, function(d) {
#     process_covariates(
#       covariate = "narr",
#       date = c(d, d),
#       variable = "weasd",
#       path = "/path/to/narr"
#     )
#   })
# }

## ----future-furrr, eval = FALSE-----------------------------------------------
# if (
#   requireNamespace("future", quietly = TRUE) &&
#     requireNamespace("furrr", quietly = TRUE) &&
#     requireNamespace("terra", quietly = TRUE)
# ) {
#   dates <- seq.Date(
#     as.Date("2022-01-01"),
#     as.Date("2022-01-05"),
#     by = "day"
#   )
# 
#   future::plan(future::multisession, workers = 4)
# 
#   raster_paths <- furrr::future_map_chr(dates, function(d) {
#     worker_dir <- file.path(tempdir(), paste0("amadeus-", format(d)))
#     dir.create(worker_dir, recursive = TRUE, showWarnings = FALSE)
# 
#     processed <- amadeus::process_covariates(
#       covariate = "narr",
#       date = c(d, d),
#       variable = "weasd",
#       path = "/path/to/narr"
#     )
# 
#     out_path <- file.path(worker_dir, paste0("weasd-", format(d), ".tif"))
#     terra::writeRaster(processed, out_path, overwrite = TRUE)
#     out_path
#   })
# 
#   rasters <- lapply(raster_paths, terra::rast)
#   future::plan(future::sequential)
# }

## ----mirai, eval = FALSE------------------------------------------------------
# if (
#   requireNamespace("mirai", quietly = TRUE) &&
#     requireNamespace("terra", quietly = TRUE)
# ) {
#   dates <- seq.Date(
#     as.Date("2022-01-01"),
#     as.Date("2022-01-05"),
#     by = "day"
#   )
# 
#   mirai::daemons(4)
# 
#   raster_paths <- mirai::mirai_map(dates, .f = function(d) {
#     worker_dir <- file.path(tempdir(), paste0("amadeus-", format(d)))
#     dir.create(worker_dir, recursive = TRUE, showWarnings = FALSE)
# 
#     processed <- amadeus::process_covariates(
#       covariate = "narr",
#       date = c(d, d),
#       variable = "weasd",
#       path = "/path/to/narr"
#     )
# 
#     out_path <- file.path(worker_dir, paste0("weasd-", format(d), ".tif"))
#     terra::writeRaster(processed, out_path, overwrite = TRUE)
#     out_path
#   })
# 
#   rasters <- lapply(unlist(raster_paths), terra::rast)
#   mirai::daemons(0)
# }

## ----targets, eval = FALSE----------------------------------------------------
# if (
#   requireNamespace("targets", quietly = TRUE) &&
#     requireNamespace("tarchetypes", quietly = TRUE) &&
#     requireNamespace("terra", quietly = TRUE)
# ) {
#   library(targets)
# 
#   tar_option_set(packages = c("amadeus", "terra"))
# 
#   dates <- seq.Date(
#     as.Date("2022-01-01"),
#     as.Date("2022-01-05"),
#     by = "day"
#   )
# 
#   list(
#     tar_target(date_grid, dates),
#     tarchetypes::tar_map(
#       values = data.frame(date = dates),
#       tar_target(
#         processed_path,
#         {
#           processed <- process_covariates(
#             covariate = "narr",
#             date = c(date, date),
#             variable = "weasd",
#             path = "/path/to/narr"
#           )
#           out_path <- file.path(
#             tempdir(),
#             paste0("weasd-", format(date), ".tif")
#           )
#           terra::writeRaster(processed, out_path, overwrite = TRUE)
#           out_path
#         },
#         format = "file"
#       )
#     )
#   )
# }

