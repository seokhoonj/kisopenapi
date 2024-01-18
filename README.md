# kisopenapi package

Korea Investment & Securites Open Trading API using R (In-development)

<!-- badges: start -->

[![CRAN status](https://www.r-pkg.org/badges/version/kisopenapi)](https://CRAN.R-project.org/package=kisopenapi) [![R-CMD-check](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Introduction

-   This package is created for R users, referring to the Korea Investment & Securities Open Trading API.

-   First, open an account Korea Investment & Securites and then generate an app key and app secret from `https://apiportal.koreainvestment.com/`.

-   For more information, please refer to the following official website `https://github.com/koreainvestment/open-trading-api/tree/main`.

-   해당 패키지는 한국투자증권 Open Trading API를 참조하여, R 사용자가 활용할 수 있게 일부 재구성한 것입니다.

-   먼저 계좌를 개설한 후 `https://apiportal.koreainvestment.com/`에서 app key와 app secret을 생성합니다.

-   자세한 내용은 `https://github.com/koreainvestment/open-trading-api/tree/main`에 설명되어 있습니다.

## Installation

``` r
devtools::install_packages("seokhoonj/kisopenapi")
```

## Example

``` r
# load library
# 패키지 로드
library(kisopenapi)

# set account number and account product code
# 계좌번호 8자리를와 계좌상품코드를 환경변수에 입력
set_cano("your account number") # 8 digits
set_acnt_prdt_cd("01") # your account product code 2 digits

# set kis app key and app secret
# 생성한 app key와 app secret도 환경변수에 입력 
set_app_key("your app key")
set_app_secret("your app secret")

# or you can set .Renviron file permanently
# 위의 4가지 변수를 환경변수에 영구히 저장
usethis::edit_r_environ()
# paste KIS_CANO="YOUR ACCOUNT NUMBER"
# paste KIS_ACNT_PRDT_CD="01"
# paste KIS_APP_KEY="YOUR APP KEY"
# paste KIS_APP_SECRET="YOUR APP SECRET"

# generate an access token using app key and app secret
# An access token is issued once a day basically, and if tokens are issued frequently, your access might be restricted
# app key와 app secret을 활용하여 엑세스 토큰을 생성
# 접근 토큰은 1일 1회 발급이 원칙이며, 유효기간내 잦은 토큰 발급 발생 시 이용시 제한 가능
set_auth()

# get balance
# 계좌잔고 확인
get_balance()

# get data (samsung electronics)
# 가격 데이터 추출
get_current_price("005930")
get_stock_history("005930")

# buy
# 매수
kis_buy(stock_code = "005930", order_qty = 1, order_price = "price_you_want")

# sell
# 매도
kis_sell(stock_code = "005930", order_qty = 1, order_price = "price_you_want")

# get orders
# 주문 내역
get_orders()

# cancel
# 주문 취소
kis_cancel_all()
```

## Reference

-   KIS github repo: <https://github.com/koreainvestment/open-trading-api/tree/main>
