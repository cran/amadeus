## ----eval = FALSE-------------------------------------------------------------
# # Interactively prompts for the token, then writes to ~/.Renviron
# setup_nasa_token(method = "renviron")

## ----eval = FALSE-------------------------------------------------------------
# setup_nasa_token(method = "renviron", token = "your_token_here")

## ----eval = FALSE-------------------------------------------------------------
# # Saves token to ~/.nasa_earthdata_token (permissions set to user-only)
# setup_nasa_token(method = "file", token = "your_token_here")

## ----eval = FALSE-------------------------------------------------------------
# download_data(
#   dataset_name = "sedac_population",
#   year = "2020",
#   data_format = "GeoTIFF",
#   data_resolution = "60 minute",
#   directory_to_save = "./sedac_population",
#   acknowledgement = TRUE,
#   nasa_earth_data_token = "~/.nasa_earthdata_token"
# )

## ----eval = FALSE-------------------------------------------------------------
# # Sets the token for the current R session only (lost on exit)
# setup_nasa_token(method = "session", token = "your_token_here")

## ----eval = FALSE-------------------------------------------------------------
# Sys.setenv(NASA_EARTHDATA_TOKEN = "your_token_here")

## ----eval = FALSE-------------------------------------------------------------
# # NASA_EARTHDATA_TOKEN is read automatically from the environment
# download_data(
#   dataset_name = "sedac_population",
#   year = "2020",
#   data_format = "GeoTIFF",
#   data_resolution = "60 minute",
#   directory_to_save = "./sedac_population",
#   acknowledgement = TRUE
# )

## ----echo = FALSE-------------------------------------------------------------
to_cat <-
  paste0(
    "Using token from environment variable: NASA_EARTHDATA_TOKEN\n",
    "Downloading requested files...\n",
    "Requested files have been downloaded.\n",
    "Unzipping files...\n",
    "Files unzipped and saved in ./sedac_population/.\n"
  )
cat(to_cat)

