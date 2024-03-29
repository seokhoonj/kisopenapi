% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{get_stock_history_by_ohlcv}
\alias{get_stock_history_by_ohlcv}
\title{get stock history by ohlcv}
\usage{
get_stock_history_by_ohlcv(stock_code, unit = "D", add_var = FALSE)
}
\arguments{
\item{stock_code}{A string specifying stock code}

\item{unit}{A string specifying day, week, month}

\item{add_var}{A boolean adding volitility and percentage change}
}
\value{
stock history by ohlcv data frame
}
\description{
Get stock history by open, high, low, close, volume.
}
\examples{
# get stock history
\dontrun{
get_stock_history_by_ohlcv("005930")
}

}
