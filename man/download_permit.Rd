% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_auxiliary.R
\name{download_permit}
\alias{download_permit}
\title{Check data download acknowledgement}
\usage{
download_permit(acknowledgement)
}
\arguments{
\item{acknowledgement}{logical(1). Whether to
start downloading}
}
\value{
NULL; returns a stop error if the acknowledgement is FALSE
}
\description{
Return an error if the \code{acknowledgement = FALSE}.
}
\note{
The \code{acknowledgement} parameter is designed to help users avoid
accidentally initiating a very large data download that may take a very long
time to run or exceed machine capabilities.
}
\keyword{internal}
