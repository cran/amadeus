% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process.R
\name{process_ecoregion}
\alias{process_ecoregion}
\title{Process ecoregion data}
\usage{
process_ecoregion(path = NULL, extent = NULL, ...)
}
\arguments{
\item{path}{character(1). Path to Ecoregion Shapefiles}

\item{extent}{numeric(4) or SpatExtent giving the extent of the raster
if \code{NULL} (default), the entire raster is loaded}

\item{...}{Placeholders.}
}
\value{
a \code{SpatVector} object
}
\description{
The \code{\link{process_ecoregion}} function imports and cleans raw ecoregion
data, returning a \code{SpatVector} object.
}
\note{
The function will fix Tukey's bridge in Portland, ME.
This fix will ensure that the EPA air quality monitoring sites
will be located within the ecoregion.
}
\examples{
## NOTE: Example is wrapped in `\dontrun{}` as function requires a large
##       amount of data which is not included in the package.
\dontrun{
ecoregion <- process_ecoregion(
  path = "./data/epa_ecoregion.gpkg"
)
}
}
\author{
Insang Song
}
