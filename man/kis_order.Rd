% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/order.R
\name{kis_order}
\alias{kis_order}
\alias{kis_buy}
\alias{kis_sell}
\title{KIS order}
\usage{
kis_order(
  stock_code,
  order_qty,
  order_price,
  prdt_code,
  order_type = "00",
  buy_flag = TRUE
)

kis_buy(stock_code, order_qty, order_price, prdt_code, order_type = "00")

kis_sell(stock_code, order_qty, order_price, prdt_code, order_type = "00")
}
\arguments{
\item{stock_code}{A string specifying stock code}

\item{order_qty}{A numeric or string specifying order quantity}

\item{order_price}{A numeric or string specifying order price}

\item{prdt_code}{A string specifying account product code}

\item{order_type}{A string specifying order type}

\item{buy_flag}{A boolean specifying flag}
}
\value{
A list contains rt_cd: return code, msg_cd: message code,
msg1: message

An order result
}
\description{
Order stocks.
}
\examples{
\dontrun{
## buy
kis_buy(
  stock_code = "stock code",
  order_qty = "your order quantity",
  order_price = "your order price"
)
## sell
kis_sell(
  stock_code = "stock code",
  order_qty = "your order quantity",
  order_price = "your order price"
)
}

}
