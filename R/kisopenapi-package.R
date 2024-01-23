#' @description
#' This package allows users to easily access various financial services using
#' the trading open API provided by Korea Investment & Securities (KIS).\cr
#' the KIS open API provides request/reponse information and error messages.\cr
#' To use this package, you will first need to open a Korea investment &
#' securities account, and get your app key and app secret from the website
#' \url{https://apiportal.koreainvestment.com/}.\cr
#' Once you have your app key and app secret, you can save those as environment
#' variables for the current session using the \code{\link{set_trading_env}}
#' functions.\cr
#' Alternatively, you can set those permanently by adding the following line to
#' your .Renviron file:
#' # For real trading
#' KIS_CANO="YOUR ACCOUNT NUMBER" (your account)\cr
#' KIS_ACNT_PRDT_CD="01" (your account product code, mainly `01`)\cr
#' KIS_APP_KEY="YOUR APP KEY"\cr
#' KIS_APP_SECRET="YOUR APP SECRET"
#' # For paper trading
#' KIS_PAPER_CANO="YOUR PAPER ACCOUNT NUMBER" (your paper account)\cr
#' KIS_PAPER_ACNT_PRDT_CD="01" (your paper account product code mainly `01`)\cr
#' KIS_PAPER_APP_KEY="YOUR PAPER APP KEY"\cr
#' KIS_PAPER_APP_SECRET="YOUR PAPER APP SECRET"\cr
#'
#' Any functions that require your environemt variables try to retrieve those via\cr
#'
#' \code{Sys.getenv("KIS_CANO")}\cr
#' \code{Sys.getenv("KIS_ACNT_PRDT_CD")}\cr
#' \code{Sys.getenv("KIS_APP_KEY")}\cr
#' \code{Sys.getenv("KIS_APP_SECRET")}\cr
#' \code{Sys.getenv("KIS_PAPER_CANO")}\cr
#' \code{Sys.getenv("KIS_PAPER_ACNT_PRDT_CD")}\cr
#' \code{Sys.getenv("KIS_PAPER_APP_KEY")}\cr
#' \code{Sys.getenv("KIS_PAPER_APP_SECRET")}\cr
#'
#' unless account number, account product code, app key and app secret are
#' explicitly specified as function arguments. and if you've already registered
#' both trading environment variables(live and paper), you can easily change the
#' environment and use the same functions.
#' @keywords internal
#' @importFrom cli style_hyperlink
#' @importFrom data.table data.table rbindlist shift
#' @importFrom httr2 req_body_json req_error req_headers req_perform
#'  req_url_query request resp_body_json
#' @importFrom jsonlite toJSON
#' @importFrom utils globalVariables head tail
"_PACKAGE"
