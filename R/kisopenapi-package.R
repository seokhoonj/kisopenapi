#' @description
#' This package allows users to easily access various financial services using
#' the trading open API provided by Korea Investment & Securities (KIS).
#' the KIS open API provides request/reponse information and error messages.
#' To use this package, you will first need to open a Korea investment &
#' securities account, and get your app key and app secret from the website
#' \url{https://apiportal.koreainvestment.com/}. Once you have your app key and
#' app secret, you can save those as environment variables for the current
#' session using the \code{\link{set_trading_env}} functions.
#' Alternatively, you can set those permanently by adding the following line to
#' your .Renviron file:
#' # For real trading
#' KIS_CANO="YOUR ACCOUNT NUMBER" (first 8 digits of your account)
#' KIS_ACNT_PRDT_CD="01" (last 2 digits of your account)
#' KIS_APP_KEY="YOUR APP KEY"
#' KIS_APP_SECRET="YOUR APP SECRET"
#' # For paper trading
#' KIS_PAPER_CANO="YOUR PAPER ACCOUNT NUMBER" (first 8 digits of your paper account)
#' KIS_PAPER_ACNT_PRDT_CD="01" (last 2 digits of your paper account)
#' KIS_PAPER_APP_KEY="YOUR PAPER APP KEY"
#' KIS_PAPER_APP_SECRET="YOUR PAPER APP SECRET"
#' Any functions that require your environemt variables try to retrieve those via
#' \code{Sys.getenv("KIS_CANO")}, \code{Sys.getenv("KIS_ACNT_PRDT_CD")},
#' \code{Sys.getenv("KIS_APP_KEY")}, \code{Sys.getenv("KIS_APP_SECRET")}
#' \code{Sys.getenv("KIS_PAPER_CANO")}, \code{Sys.getenv("KIS_PAPER_ACNT_PRDT_CD")},
#' \code{Sys.getenv("KIS_PAPER_APP_KEY")}, \code{Sys.getenv("KIS_PAPER_APP_SECRET")}
#' (unless account number, account product code, app key and app secret are
#' explicitly specified as function arguments).
#' and you've already registered both trading environment variables(live and
#' paper), you can easily change the environment and use the same functions.
#' @keywords internal
#' @importFrom cli style_hyperlink
#' @importFrom data.table data.table rbindlist shift
#' @importFrom httr2 req_body_json req_error req_headers req_perform
#'  req_url_query request resp_body_json
#' @importFrom jsonlite toJSON
#' @importFrom utils globalVariables head tail
"_PACKAGE"
