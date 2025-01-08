## ----setup, include = FALSE---------------------------------------------------
# packages
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = ""
)
library(amadeus)

## ----eval = FALSE-------------------------------------------------------------
#  dir <- tempdir()
#  amadeus::download_data(
#    dataset_name = "gridmet",
#    variable = "Near-Surface Specific Humidity",
#    year = c(2019, 2020),
#    directory_to_save = dir,
#    acknowledgement = TRUE,
#    download = TRUE,
#    remove_command = TRUE,
#    hash = TRUE
#  )

## ----echo = FALSE-------------------------------------------------------------
cat('[1] "aa5116525468299d1fc483b108b3e841fc40d7e5"')

## ----eval = FALSE-------------------------------------------------------------
#  list.files(dir, recursive = TRUE, pattern = "sph")

## ----echo = FALSE-------------------------------------------------------------
cat('[1] "sph/sph_2019.nc" "sph/sph_2020.nc"')

## ----eval = FALSE-------------------------------------------------------------
#  sph_process <- amadeus::process_covariates(
#    covariate = "gridmet",
#    variable = "Near-Surface Specific Humidity",
#    date = c("2019-12-18", "2020-01-10"),
#    path = file.path(dir, "/sph")
#  )

## ----eval = FALSE-------------------------------------------------------------
#  sph_process

## ----echo = FALSE-------------------------------------------------------------
cat('class       : SpatRaster 
dimensions  : 585, 1386, 24  (nrow, ncol, nlyr)
resolution  : 0.04166667, 0.04166667  (x, y)
extent      : -124.7875, -67.0375, 25.04583, 49.42083  (xmin, xmax, ymin, ymax)
coord. ref. : lon/lat WGS 84 (EPSG:4326) 
sources     : sph_2019.nc  (14 layers) 
              sph_2020.nc  (10 layers) 
varnames    : sph (near-surface specific humidity) 
              sph (near-surface specific humidity) 
names       : sph_20191218, sph_20191219, sph_20191220, sph_20191221, sph_20191222, sph_20191223, ... 
unit        :        kg/kg,        kg/kg,        kg/kg,        kg/kg,        kg/kg,        kg/kg, ... 
time (days) : 2019-12-18 to 2020-01-10 
')

## ----eval = FALSE-------------------------------------------------------------
#  terra::plot(sph_process[[1]])

## ----eval = FALSE-------------------------------------------------------------
#  library(tigris)
#  sph_covar <- amadeus::calculate_covariates(
#    covariate = "gridmet",
#    from = sph_process,
#    locs = tigris::counties("CA", year = 2019),
#    locs_id = "NAME",
#    radius = 0,
#    geom = "terra"
#  )

## ----eval = FALSE-------------------------------------------------------------
#  sph_covar

## ----echo = FALSE-------------------------------------------------------------
cat('class       : SpatVector 
geometry    : polygons 
dimensions  : 1392, 3  (geometries, attributes)
extent      : -124.482, -114.1312, 32.52883, 42.0095  (xmin, xmax, ymin, ymax)
coord. ref. : lon/lat WGS 84 (EPSG:4326) 
names       :          NAME       time    sph_0
type        :         <chr>   <POSIXt>    <num>
values      :        Sierra 2019-12-18 0.003101
                 Sacramento 2019-12-18 0.005791
              Santa Barbara 2019-12-18 0.004594
')

