# kisopenapi package

<!-- badges: start -->

[![CRAN status](https://www.r-pkg.org/badges/version/kisopenapi)](https://CRAN.R-project.org/package=kisopenapi) [![R-CMD-check](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/kisopenapi/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

Korea Investment & Securites (KIS) Open Trading API using R

한국투자증권 (KIS) Open Trading API using R

## Introduction

-   This package is created for R users, referring to the Korea Investment & Securities Open Trading API.

-   First, open an account Korea Investment & Securites and then generate an app key and app secret from <https://apiportal.koreainvestment.com/>.

-   For more information, please refer to the following official website <https://github.com/koreainvestment/open-trading-api/tree/main>.

-   해당 패키지는 한국투자증권 Open Trading API (REST) 부분을 참조하여, R 사용자가 쉽게 활용할 수 있게 재구성한 것입니다.

-   먼저 계좌를 개설한 후 <https://apiportal.koreainvestment.com/>에서 app key와 app secret을 생성합니다.

-   자세한 내용은 <https://github.com/koreainvestment/open-trading-api/tree/main>에 설명되어 있습니다.

## Installation

``` r
devtools::install_packages("seokhoonj/kisopenapi")
```

## Setting environment variables

``` r
# load library
# 패키지 로드
library(kisopenapi)

# open .Renvrion file
# .Renviron 파일을 열고
usethis::edit_r_environ()

# paste the following environment variables with your values.
# 다음 환경변수를 작성하여 붙여 넣는다.

# For live trading
KIS_CANO="" # 계좌번호 8자리
KIS_ACNT_PRDT_CD="" # 계좌 상품코드 2자리, 보통 "01"
KIS_APP_KEY="" # 생성한 app key 
KIS_APP_SECRET="" # 생성한 app secret

# For paper trading
KIS_PAPER_CANO="" # 모의계좌번호 8자리
KIS_PAPER_ACNT_PRDT_CD="" # 모의계좌 상품코드 2자리, 보통 "01"
KIS_PAPER_APP_KEY="" # 생성한 모의 app key
KIS_PAPER_APP_SECRET="" # 생성한 모의 app secret

# read .Renviron file you just created (or restart the R session)
# Now, these environment variables are stored permanently.
# 상기 작업이 끝나면 .Renviron 파일의 변수를 불러 온다. (혹은 R을 재시작한다.)
# 이제 이 환경변수들은 영구히 저장된다.
readRenviron("~/.Renviron") # alternatively, .rs.restartR()

# Alternatively,
# set account number, account product code, kis app key and app secret using
# `set_trading_env' function.
# but this method lasts only for the current session and disappears.
# 계좌번호 8자리, 계좌상품코드, 생성한 app key와 app secret를 `set_trading_env` 
# 함수를 활용하여 환경변수에 입력한다.
# 하지만 이 방법은 현재 세션에서만 지속되고 사라진다.
# set_trading_env(
#   cano = "your account number", # 8 digits
#   acnt_prdt_cd = "your account product code", # your account product code 2 digits
#   app_key = "your app key",
#   app_secret = "your app secret"
# ) 

# generate an access token using app key and app secret
# An access token is issued once a day basically, and if tokens are issued frequently, your access might be restricted
# It's automatically created when the functions are executed (reissued when 
# the current session ends or after 86,400 seconds)
# app key와 app secret을 활용하여 엑세스 토큰을 생성
# 접근 토큰은 1일 1회 발급이 원칙이며, 유효기간내 잦은 토큰 발급 발생 시 이용이 제한될
# 수 있음.
# 함수가 실행될 때 자동으로 실행 (세션이 종료되거나 86,400초가 지나면 재발행)
# set_auth()
```

## Examples

``` r
# get balance
# 계좌잔고 확인
get_balance() # details (data.frame)
get_balance(rt_cash_flag = TRUE) # total deposit (numeric)

# get current price (samsung electronics)
# 가격 데이터 추출 (삼성전자)
get_current_price("005930")

# get stock quotes (samsung electronic)
# 시세 데이터 추출 (삼성전자) (현재 30개 제한)
get_stock_qutoes("005930")

# get history data (samsung electronics)
# 가격 history 데이터 추출 (삼성전자) (현재 30개 제한)
get_stock_history("005930", unit = "D") # unit: D(day), W(week), M(month)
get_stock_history_by_ohlcv("005930", unit = "D", add_var = TRUE)

# get stock investors (samsung electronics)
# 투자자 데이터 추출 (삼성전자)
get_stock_investor("005930")

# get buyable cash
# 매수 가능 현금 확인
get_buyable_cash()


# hash key is applied to all orders, revise and cancel functions
# 모든 주문관련 함수에는 자동으로 해시키가 적용

# buy
# 매수
kis_buy(stock_code = "005930", order_qty = 1, order_price = "price_you_want")

# sell
# 매도
kis_sell(stock_code = "005930", order_qty = 1, order_price = "price_you_want")

# get orders
# 주문 내역
get_orders()

# get order history
# 주문 내역 history
get_order_history(sdt = "20240102")

# revise (get the order number and branch information via `get_orders()`)
# 주문 정정 (`get_orders()` 함수를 통해 정보 취득)
kis_revise(
  order_no = "your order number", order_branch = "your order branch",
  order_qty = 1, order_price = "price you want"
)

# cancel
# 주문 취소
kis_cancel_all()

# Change the trading environment (live -> paper, paper -> live)
# 거래 계좌 변경 (실전투자 -> 모의투자, 모의투자 -> 실전투자) # default 실전투자
change_trading_env()

# Check the current trading environment (live or paper)
# 현재 거래 환경 확인 (실전 or 모의)
print_trading_env()

# `get_orders` function is not supproted for the paper trading enviroment.
# `get_orders` 함수는 모의투자에서 아직 지원되지 않는 것으로 보입니다.
```

## Reference

-   KIS official git repo: <https://github.com/koreainvestment/open-trading-api/tree/main>
