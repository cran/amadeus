## ----setup, include = FALSE---------------------------------------------------
# packages
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = ""
)
library(amadeus)

## ----eval = FALSE-------------------------------------------------------------
# dir <- tempdir()
# amadeus::download_data(
#   dataset_name = "terraclimate",
#   variable = "Wind Speed",
#   year = c(2021, 2022),
#   directory_to_save = dir,
#   acknowledgement = TRUE,
#   download = TRUE,
#   remove_command = TRUE,
#   hash = TRUE
# )

## ----echo = FALSE-------------------------------------------------------------
cat('[1] "344cddba906371b701f661ccebeef3f427b2d8ec"')

## ----eval = FALSE-------------------------------------------------------------
# list.files(dir, recursive = TRUE, pattern = "ws")

## ----echo = FALSE-------------------------------------------------------------
cat('[1] "ws/ws_2021.nc" "ws/ws_2022.nc"')

## ----eval = FALSE-------------------------------------------------------------
# ws_process <- amadeus::process_covariates(
#   covariate = "terraclimate",
#   variable = "Wind Speed",
#   date = c("2021-12-28", "2022-01-03"),
#   path = file.path(dir, "/ws")
# )

## ----eval = FALSE-------------------------------------------------------------
# ws_process

## ----echo = FALSE-------------------------------------------------------------
cat('class       : SpatRaster 
dimensions  : 4320, 8640, 2  (nrow, ncol, nlyr)
resolution  : 0.04166667, 0.04166667  (x, y)
extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
coord. ref. : +proj=longlat +ellps=WGS84 +no_defs 
sources     : ws_2021.nc  
              ws_2022.nc  
varnames    : ws (wind speed) 
              ws (wind speed) 
names       : ws_202112, ws_202201 
unit        :       m/s,       m/s 
time (days) : 2021-12-01 to 2022-01-01 
')

## ----eval = FALSE-------------------------------------------------------------
# terra::plot(ws_process[[1]])

