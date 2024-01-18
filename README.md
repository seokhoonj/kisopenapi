# kisopenapi

## Introduction

Korea Investment & Securites Open Trading API using R (In-development) 
<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/kisopenapi)](https://CRAN.R-project.org/package=kisopenapi)
[![R-CMD-check](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Installation

``` r
devtools::install_packages("seokhoonj/kisopenapi")
```

## Example

``` r
# set kis app key and app secret
set_app_key() # or usethis::edit_r_environ(), paste KIS_APP_KEY="YOUR APP KEY"
set_app_secret() # or usethis::edit_r_environ(), paste KIS_APP_SECRET="YOUR APP SECRET"

# generate an access token
set_auth()

# get balance
get_balance()

# get data
get_current_price("005930")
get_stock_history("005930")

# buy
kis_buy(stock_code = "005930", order_qty = 1, order_price = "price_you_want") # kis_sell()

# get orders
get_orders()

# cancel
kis_cancel_all()
```

## Reference

KIS github repo: [https://github.com/koreainvestment/open-trading-api/tree/main](https://github.com/koreainvestment/open-trading-api/tree/main)
