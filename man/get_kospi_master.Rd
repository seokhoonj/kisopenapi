% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/master.R
\name{get_kospi_master}
\alias{get_kospi_master}
\alias{get_kosdaq_master}
\title{Get KOSPI (KOSDAQ) master}
\usage{
get_kospi_master()

get_kosdaq_master()
}
\value{
a data.frame
}
\description{
Download KOSPI (KOSDAQ) master file in temp directory and get the data from the file
}
\examples{
# get kospi master
\dontrun{
kospi <- get_kospi_master()
View(kospi)}

# get kosdaq master
\dontrun{
kosdaq <- get_kosdaq_master()
View(kosdaq)}

}
