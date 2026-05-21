## ----include = FALSE----------------------------------------------------------
# packages
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(knitr)
library(testthat)
library(devtools)

## ----setup--------------------------------------------------------------------
library(amadeus)

## ----echo = FALSE-------------------------------------------------------------
functions <- c(
  "download_aqs",
  "download_cropscape",
  "download_ecoregion",
  "download_edgar",
  "download_geos",
  "download_gmted",
  "download_gridmet",
  "download_groads",
  "download_hms",
  "download_huc",
  "download_koppen_geiger",
  "download_merra2",
  "download_modis",
  "download_narr",
  "download_nei",
  "download_nlcd",
  "download_population",
  "download_prism",
  "download_terraclimate",
  "download_tri"
)
source <- c(
  "US EPA Air Data Pre-Generated Data Files",
  paste0(
    "USDA National Agricultural Statistics Service ",
    "CropScape (Cropland Data Layer)"
  ),
  "US EPA Ecoregions",
  "EU JRC Emissions Database for Global Atmospheric Research (EDGAR)",
  "NASA Goddard Earth Observing System Composition Forecasting (GEOS-CF)",
  "USGS Global Multi-resolution Terrain Elevation Data (GMTED2010)",
  "Climatology Lab GridMET",
  "NASA SEDAC Global Roads Open Access Data Set",
  "NOAA Hazard Mapping System Fire and Smoke Product",
  "USGS National Hydrography Dataset (NHD)",
  "Köppen-Geiger Climate Classification (Beck et al., 2018)",
  paste0(
    "NASA Modern-Era Retrospective analysis for Research and ",
    "Applications, Version 2 (MERRA-2)"
  ),
  "NASA Moderate Resolution Imaging Spectroradiometer (MODIS)",
  "NOAA NCEP North American Regional Reanalysis (NARR)",
  "US EPA National Emissions Inventory (NEI)",
  "MRLC Consortium National Land Cover Database (NLCD)",
  "NASA SEDAC UN WPP-Adjusted Population Density",
  "Parameter Elevation Regression on Independent Slopes Model (PRISM)",
  "Climatology Lab TerraClimate",
  "US EPA Toxic Release Inventory (TRI) Program"
)

link <- c(
  "https://aqs.epa.gov/aqsweb/airdata/download_files.html",
  "https://nassgeodata.gmu.edu/CropScape/",
  "https://www.epa.gov/eco-research/ecoregions",
  "https://edgar.jrc.ec.europa.eu/",
  "https://gmao.gsfc.nasa.gov/GEOS_systems/",
  "https://www.usgs.gov/coastal-changes-and-impacts/gmted2010",
  "https://www.climatologylab.org/gridmet.html",
  "https://data.nasa.gov/dataset/global-roads-open-access-data-set-version-1-groadsv1",
  "https://www.ospo.noaa.gov/products/land/hms.html#0",
  "https://www.epa.gov/waterdata/get-nhdplus-national-hydrography-dataset-plus-data",
  "https://www.nature.com/articles/sdata2018214",
  "https://gmao.gsfc.nasa.gov/reanalysis/MERRA-2/",
  "https://modis.gsfc.nasa.gov/data/",
  "https://psl.noaa.gov/data/gridded/data.narr.html",
  "https://www.epa.gov/air-emissions-inventories",
  "https://www.mrlc.gov/data",
  paste0(
    "https://earthdata.nasa.gov/data/catalog/",
    "sedac-ciesin-sedac-gpwv4-apdens-wpp-2015-r11-4.11"
  ),
  paste0(
    "https://elibrary.asabe.org/abstract.asp??JID=3&",
    "AID=3101&CID=t2000&v=43&i=6&T=1"
  ),
  "https://www.climatologylab.org/terraclimate.html",
  paste0(
    "https://www.epa.gov/toxics-release-inventory-tri-program/",
    "tri-basic-data-files-calendar-years-1987-present"
  )
)

source <- paste0(
  "[",
  source,
  "](",
  link,
  ")"
)

functions_sources <- data.frame(functions, source)
functions_sources_sorted <- functions_sources[order(functions_sources$source), ]
colnames(functions_sources_sorted) <- c("Download Function", "Data Source")
kable(functions_sources_sorted,
  caption =
    "Source-specific download functions and data sources"
)

## -----------------------------------------------------------------------------
names(formals(download_hms))
names(formals(download_narr))

## ----echo = FALSE-------------------------------------------------------------
parameter <- c(
  "directory_to_save",
  "acknowledgement",
  "download"
)
type <- c("Character", "Logical", "Logical")
description <- c(
  paste0(
    "There must be a directory to save downloaded ",
    "data. Default = './input/DATASET_NAME/'."
  ),
  paste0(
    "User must acknowledge that downloading geospatial ",
    "data can be very large and may use lots of machine ",
    "storage and memory."
  ),
  paste0(
    "DEPRECATED. Downloads now use httr2 by default. ",
    "When FALSE, the function returns early with a list ",
    "of URLs and destination file paths (useful for ",
    "unit tests — see [Unit Tests])."
  )
)
parameter_descriptions <- data.frame(parameter, type, description)
colnames(parameter_descriptions) <- c("Parameter", "Type", "Description")
kable(parameter_descriptions)

## -----------------------------------------------------------------------------
# user defined parameters
dates <- c("2023-12-28", "2024-01-02")

## -----------------------------------------------------------------------------
date_sequence <- seq(
  as.Date(dates[1], format = "%Y-%m-%d"),
  as.Date(dates[2], format = "%Y-%m-%d"),
  "day"
)
date_sequence <- gsub("-", "", as.character(date_sequence))
date_sequence

## -----------------------------------------------------------------------------
# user defined parameters
data_format <- "Shapefile"
suffix <- ".zip"
directory_to_save <- "./data/"

## -----------------------------------------------------------------------------
all_urls <- character()
all_destfiles <- character()

for (d in seq_along(date_sequence)) {
  year <- substr(date_sequence[d], 1, 4)
  month <- substr(date_sequence[d], 5, 6)
  base <- "https://satepsanone.nesdis.noaa.gov/pub/FIRE/web/HMS/Smoke_Polygons/"
  url <- paste0(
    base,
    data_format,
    "/",
    year,
    "/",
    month,
    "/hms_smoke",
    date_sequence[d],
    suffix
  )
  destfile <- paste0(
    directory_to_save,
    "hms_smoke_",
    data_format,
    "_",
    date_sequence[d],
    suffix
  )
  all_urls <- c(all_urls, url)
  all_destfiles <- c(all_destfiles, destfile)
}
all_urls

## ----eval = FALSE-------------------------------------------------------------
# result <- download_data(
#   dataset_name = "hms",
#   date = c("2023-12-28", "2024-01-02"),
#   data_format = "Shapefile",
#   directory_to_save = "./data/",
#   acknowledgement = TRUE,
#   download = FALSE
# )
# # result$urls       — character vector of download URLs
# # result$destfiles  — character vector of destination paths
# # result$n_files    — integer count

## -----------------------------------------------------------------------------
download_unzip <-
  function(file_name,
           directory_to_unzip,
           unzip = TRUE) {
    if (!unzip) {
      cat(paste0("Downloaded files will not be unzipped.\n"))
      return(NULL)
    }
    cat(paste0("Unzipping files...\n"))
    unzip(file_name,
      exdir = directory_to_unzip
    )
    cat(paste0(
      "Files unzipped and saved in ",
      directory_to_unzip,
      ".\n"
    ))
  }

## -----------------------------------------------------------------------------
download_remove_zips <-
  function(remove = FALSE,
           download_name) {
    if (remove) {
      cat(paste0("Removing download files...\n"))
      file.remove(download_name)
      cat(paste0("Download files removed.\n"))
    }
  }

## ----eval = FALSE-------------------------------------------------------------
# for (f in seq_along(all_destfiles)) {
#   download_unzip(
#     file_name = all_destfiles[f],
#     directory_to_unzip = directory_to_save,
#     unzip = TRUE
#   )
# }
# download_remove_zips(
#   download_name = all_destfiles,
#   remove = FALSE
# )

## ----echo = FALSE-------------------------------------------------------------
for (f in seq_along(date_sequence)) {
  cat(paste0("Unzipping files...\n"))
  cat(paste0(
    "Files unzipped and saved in ",
    directory_to_save,
    ".\n"
  ))
}

## ----eval = FALSE-------------------------------------------------------------
# list.files(path = directory_to_save)

## ----echo = FALSE-------------------------------------------------------------
zips <- paste0("hms_smoke_Shapefile_", date_sequence, ".zip")
for (s in seq_along(date_sequence)) {
  shps <- c(
    paste0("hms_smoke", date_sequence[s], ".dbf"),
    paste0("hms_smoke", date_sequence[s], ".prj"),
    paste0("hms_smoke", date_sequence[s], ".shp"),
    paste0("hms_smoke", date_sequence[s], ".shx")
  )
  zips <- c(zips, shps)
}
zips

## -----------------------------------------------------------------------------
check_urls <- function(
  urls = urls,
  size = NULL
) {
  if (is.null(size)) {
    cat(paste0("URL sample size is not defined.\n"))
    return(NULL)
  }
  if (length(urls) < size) {
    size <- length(urls)
  }
  url_sample <- sample(urls, size, replace = FALSE)
  url_status <- sapply(url_sample, function(url) {
    tryCatch({
      status <- httr2::request(url) |>
        httr2::req_method("HEAD") |>
        httr2::req_error(is_error = \(resp) FALSE) |>
        httr2::req_perform() |>
        httr2::resp_status()
      Sys.sleep(1)
      status %in% c(200L, 206L)
    }, error = function(e) FALSE)
  })
  return(url_status)
}

## ----eval = FALSE-------------------------------------------------------------
# library(testthat)
# testthat::test_that(
#   "Valid dates return HTTP response status = 200.",
#   {
#     # parameters
#     test_start <- "2023-12-28"
#     test_end <- "2024-01-02"
#     test_directory <- "./data/"
#     # download = FALSE returns a list with $urls (no files downloaded)
#     result <- download_data(
#       dataset_name = "hms",
#       date = c(test_start, test_end),
#       data_format = "Shapefile",
#       directory_to_save = test_directory,
#       acknowledgement = TRUE,
#       download = FALSE
#     )
#     urls <- result$urls
#     url_status <- check_urls(urls = urls, size = 6)
#     # test for true
#     expect_true(all(url_status))
#   }
# )

## ----echo = FALSE-------------------------------------------------------------
library(testthat)
testthat::test_that(
  "Valid dates return HTTP response status = 200.",
  {
    # parameters
    test_start <- "2023-12-28"
    test_end <- "2024-01-02"
    test_directory <- "../inst/extdata/"
    # download = FALSE returns a list with $urls (no files downloaded)
    result <- suppressWarnings(download_data(
      dataset_name = "hms",
      date = c(test_start, test_end),
      data_format = "Shapefile",
      directory_to_save = test_directory,
      acknowledgement = TRUE,
      download = FALSE
    ))
    urls <- result$urls
    url_status <- check_urls(urls = urls, size = 6)
    # test for true
    expect_true(all(url_status))
  }
)

## -----------------------------------------------------------------------------
testthat::test_that(
  "Invalid dates cause function to fail.",
  {
    # parameters
    test_start <- "1800-01-01"
    test_end <- "1800-01-02"
    test_directory <- "../inst/extdata/"
    # test for error
    testthat::expect_error(
      download_data(
        dataset_name = "hms",
        date = c(test_start, test_end),
        data_format = "Shapefile",
        directory_to_save = test_directory,
        acknowledgement = TRUE,
        download = FALSE,
        unzip = FALSE,
        remove_zip = FALSE
      )
    )
  }
)

## -----------------------------------------------------------------------------
testthat::test_that(
  "Invalid dates cause function to fail.",
  {
    # parameters
    test_start <- "1800-01-01"
    test_end <- "1800-01-02"
    test_directory <- "../inst/extdata/"
    # test for error
    testthat::expect_error(
      download_hms(
        date = c(test_start, test_end),
        data_format = "Shapefile",
        directory_to_save = test_directory,
        acknowledgement = TRUE,
        download = FALSE,
        unzip = FALSE,
        remove_zip = FALSE
      )
    )
  }
)

## -----------------------------------------------------------------------------
names(formals(download_hms))

## -----------------------------------------------------------------------------
dates <- c("2023-12-28", "2024-01-02")
data_format <- "Shapefile"
data_directory <- "./download_example/"
acknowledgement <- TRUE
unzip <- TRUE # inflate (unzip) downloaded zip files
remove_zip <- FALSE # retain downloaded zip files

## ----eval = FALSE-------------------------------------------------------------
# download_data(
#   dataset_name = "hms",
#   date = dates,
#   data_format = data_format,
#   directory_to_save = data_directory,
#   acknowledgement = acknowledgement,
#   unzip = unzip,
#   remove_zip = remove_zip
# )

## ----echo = FALSE-------------------------------------------------------------
to_cat <-
  paste0(
    "Downloading requested files...\n",
    "Requested files have been downloaded.\n"
  )
cat(to_cat)
for (f in seq_along(date_sequence)) {
  cat(paste0("Unzipping files...\n"))
  cat(paste0(
    "Files unzipped and saved in ",
    data_directory,
    ".\n"
  ))
}

## ----eval = FALSE-------------------------------------------------------------
# list.files(data_directory)

## ----echo = FALSE-------------------------------------------------------------
zips <- paste0("hms_smoke_Shapefile_", date_sequence, ".zip")
for (s in seq_along(date_sequence)) {
  shps <- c(
    paste0("hms_smoke", date_sequence[s], ".dbf"),
    paste0("hms_smoke", date_sequence[s], ".prj"),
    paste0("hms_smoke", date_sequence[s], ".shp"),
    paste0("hms_smoke", date_sequence[s], ".shx")
  )
  zips <- c(zips, shps)
}
zips

## -----------------------------------------------------------------------------
download_hms

