# ============================================================================
# MIGRATION GUIDE: Updating download functions to use new method-based approach
# ============================================================================

# STEP 1: Add new download_run_method() to your package
# ------------------------------------------------------
# File: R/download_aux.R
# Action: Add the complete download_run_method() function and its helpers
#         (download_with_httr2, download_with_processx, download_generate_script)
# Status: Already created in artifacts - just copy to your package

# STEP 2: Update download_run() to show deprecation warning
# ---------------------------------------------------------
# File: R/download_aux.R

#' Run download commands (LEGACY)
#' @description
#' **DEPRECATED**: This function is maintained for backwards compatibility.
#' New code should use the `method` parameter in download functions directly,
#' which calls `download_run_method()` internally.
#'
#' Execute or skip the commands listed in the ...wget/curl_commands.txt file
#' produced by one of the data download functions.
#' @param download logical(1). Execute (\code{TRUE}) or skip (\code{FALSE}) download.
#' @param commands_txt character(1). Path of download commands
#' @param remove logical(1). Remove (\code{TRUE}) or keep (\code{FALSE}) command.
#' @return NULL; runs download commands
#' @keywords internal
#' @export
download_run <- function(
  download = FALSE,
  commands_txt = NULL,
  remove = FALSE
) {
  # Show deprecation warning once per session
  if (!isTRUE(getOption("amadeus.download_run.warned"))) {
    warning(
      "download_run() is deprecated. Use the 'method' parameter in download functions instead.\n",
      "  Old: download_modis(..., download = TRUE)\n",
      "  New: download_modis(..., method = 'httr2')\n",
      call. = FALSE
    )
    options(amadeus.download_run.warned = TRUE)
  }

  # Original implementation continues unchanged
  if (tolower(.Platform$OS.type) == "windows") {
    runner <- ""
    commands_bat <- gsub(".txt", ".bat", commands_txt)
    file.rename(commands_txt, commands_bat)
    commands_txt <- commands_bat
  } else {
    runner <- ". "
  }
  system_command <- paste0(runner, commands_txt)
  if (download == TRUE) {
    message(paste0("Downloading requested files...\n"))
    system(command = system_command, intern = TRUE)
    message(paste0("Requested files have been downloaded.\n"))
  } else {
    message(paste0("Skipping data download.\n"))
  }
  amadeus::download_remove_command(
    commands_txt = commands_txt,
    remove = remove
  )
}


# STEP 3: Create a helper function for each download type
# -------------------------------------------------------
# File: R/download_aux.R

#' Determine wget options based on data source
#' @param source character(1). Data source name
#' @return character vector of wget options or NULL
#' @keywords internal
#' @export
get_wget_opts <- function(source) {
  opts <- list(
    modis = c("-np", "-R", ".html,.tmp", "-nH", "--cut-dirs=3"),
    merra2 = NULL,
    geos = NULL,
    narr = NULL,
    gridmet = NULL
  )

  source_lower <- tolower(source)
  if (source_lower %in% names(opts)) {
    return(opts[[source_lower]])
  }
  return(NULL)
}


# STEP 4: Update download_modis() - PILOT FUNCTION
# ------------------------------------------------
# File: R/download_modis.R
# See the already-created artifact "download_modis_updated"
# Key changes:
# 1. Add method parameter with default "httr2"
# 2. Add show_progress parameter
# 3. Deprecate download parameter but keep it working
# 4. Replace download_run() call with download_run_method()
# 5. Pass MODIS-specific wget_opts

# STEP 5: Update download_merra2() - SECOND FUNCTION
# --------------------------------------------------
# File: R/download_merra2.R

# Original function signature - ADD these parameters:
download_merra2 <- function(
  collection = c("inst1_2d_asm_Nx", ...),
  date = c("2018-01-01", "2018-01-01"),
  directory_to_save = NULL,
  method = c("httr2", "processx", "wget_script"), # ADD THIS
  acknowledgement = FALSE,
  download = NULL, # CHANGE: was FALSE, now NULL
  remove_command = FALSE,
  show_progress = TRUE, # ADD THIS
  hash = FALSE
) {
  # ... [existing validation code] ...

  # ADD: Handle deprecated download parameter
  if (!is.null(download)) {
    warning(
      "Parameter 'download' is deprecated. Use 'method' parameter instead.\n",
      "  download=TRUE  -> method='processx'\n",
      "  download=FALSE -> method='wget_script'\n",
      call. = FALSE
    )
    method <- if (download) "legacy_system" else "wget_script"
  } else {
    method <- match.arg(method)
  }

  # ... [existing URL building code through the loops] ...

  # REPLACE: Instead of writing commands inside loops, collect URLs
  all_urls <- character()
  all_destfiles <- character()

  for (c in seq_along(collection)) {
    # ... [existing collection setup] ...

    for (l in seq_along(date_sequence)) {
      year <- as.character(substr(date_sequence[l], 1, 4))
      month <- as.character(substr(date_sequence[l], 5, 6))

      # Data file
      download_url <- paste0(
        base,
        esdt_name,
        ".5.12.4/",
        year,
        "/",
        month,
        "/",
        list_urls_data[l]
      )
      download_folder <- paste0(directory_to_save, collection_loop)
      if (!dir.exists(download_folder)) {
        dir.create(download_folder, recursive = TRUE)
      }
      download_name <- paste0(download_folder, "/", list_urls_data[l])

      if (amadeus::check_destfile(download_name)) {
        all_urls <- c(all_urls, download_url)
        all_destfiles <- c(all_destfiles, download_name)
      }

      # Metadata file
      download_url_metadata <- paste0(
        base,
        esdt_name,
        ".5.12.4/",
        year,
        "/",
        month,
        "/",
        list_urls_metadata[l]
      )
      download_folder_metadata <- paste0(
        directory_to_save,
        collection_loop,
        "/metadata/"
      )
      if (!dir.exists(download_folder_metadata)) {
        dir.create(download_folder_metadata, recursive = TRUE)
      }
      download_name_metadata <- paste0(
        download_folder_metadata,
        list_urls_metadata[l]
      )

      if (amadeus::check_destfile(download_name_metadata)) {
        all_urls <- c(all_urls, download_url_metadata)
        all_destfiles <- c(all_destfiles, download_name_metadata)
      }
    }
  }

  # REPLACE: Old download_sink/cat/sink/download_run approach with:
  commands_txt <- paste0(
    directory_to_save,
    "merra2_",
    date[1],
    "_",
    date[2],
    "_wget_commands.txt"
  )

  if (method == "legacy_system") {
    # Keep old behavior for true backwards compatibility
    amadeus::download_sink(commands_txt)
    for (i in seq_along(all_urls)) {
      cat(paste0("wget ", all_urls[i], " -O ", all_destfiles[i], "\n"))
    }
    sink(file = NULL)

    amadeus::download_run(
      download = TRUE,
      commands_txt = commands_txt,
      remove = remove_command
    )
  } else {
    # New method-based approach
    amadeus::download_run_method(
      method = method,
      urls = all_urls,
      destfiles = all_destfiles,
      commands_txt = commands_txt,
      token = NULL, # MERRA2 doesn't use authentication
      remove = remove_command,
      show_progress = show_progress,
      wget_opts = amadeus::get_wget_opts("merra2")
    )
  }

  return(amadeus::download_hash(hash, directory_to_save))
}


# STEP 6: Testing Strategy
# ------------------------

test_downloads <- function() {
  # Test 1: Backwards compatibility
  # Old code should still work with deprecation warning
  download_modis(
    product = "MOD09GA",
    date = "2024-01-01",
    download = FALSE, # Old parameter
    acknowledgement = TRUE
  )
  # Should see: deprecation warning + generate script

  # Test 2: New httr2 method (default)
  download_modis(
    product = "MOD09GA",
    date = "2024-01-01",
    method = "httr2", # New parameter
    acknowledgement = TRUE
  )

  # Test 3: processx method
  download_modis(
    product = "MOD09GA",
    date = "2024-01-01",
    method = "processx",
    acknowledgement = TRUE
  )

  # Test 4: Script generation
  download_modis(
    product = "MOD09GA",
    date = "2024-01-01",
    method = "wget_script",
    acknowledgement = TRUE
  )

  # Test 5: MERRA2 with new methods
  download_merra2(
    collection = "inst1_2d_int_Nx",
    date = "2024-01-01",
    method = "httr2",
    acknowledgement = TRUE
  )
}


# STEP 7: Documentation Updates
# -----------------------------

# Update NAMESPACE:
# - Export download_run_method
# - Keep download_run exported (for now)
# - Export get_wget_opts

# Update package documentation:
# - Add migration guide in vignette
# - Update function examples to use method parameter
# - Add deprecation notices to download parameter

# Update NEWS.md:
# ```
# # amadeus 1.3.0
#
# ## New features
# - Added method-based download system with three options:
#   - `method = "httr2"`: Pure R downloads (default, no system dependencies)
#   - `method = "processx"`: Managed wget downloads
#   - `method = "wget_script"`: Generate scripts for manual execution
# - All download functions now support progress tracking
#
# ## Deprecations
# - `download` parameter in download_*() functions is deprecated
# - Use `method` parameter instead
# - Old code continues to work with deprecation warnings
#
# ## Migration guide
# - `download = TRUE` → `method = "httr2"` (recommended) or `method = "processx"`
# - `download = FALSE` → `method = "wget_script"`
# ```

# STEP 8: Rollout Checklist
# -------------------------

rollout_checklist <- function() {
  checklist <- c(
    "[ ] Add download_run_method() and helpers to R/download_aux.R",
    "[ ] Add get_wget_opts() to R/download_aux.R",
    "[ ] Update download_run() with deprecation warning",
    "[ ] Update download_modis() with method parameter",
    "[ ] Test download_modis() with all three methods",
    "[ ] Update download_merra2() with method parameter",
    "[ ] Test download_merra2() with all three methods",
    "[ ] Update any other download_*() functions",
    "[ ] Update all documentation and examples",
    "[ ] Update NAMESPACE",
    "[ ] Add migration vignette",
    "[ ] Update NEWS.md",
    "[ ] Run R CMD check",
    "[ ] Test on different platforms (Windows, Linux, Mac)",
    "[ ] Release new version",
    "[ ] After 1-2 releases, consider removing deprecated parameters"
  )

  cat(paste(checklist, collapse = "\n"))
}

# STEP 9: Version Timeline Suggestion
# -----------------------------------

# Version 1.3.0 (Current):
# - Add new method-based system
# - Deprecate download parameter
# - All old code continues to work

# Version 1.4.0 (Next release):
# - Keep deprecated parameters
# - Monitor usage and feedback

# Version 2.0.0 (Future major version):
# - Remove download parameter entirely
# - Potentially remove download_run() or make it internal
# - Clean breaking change with clear migration path
