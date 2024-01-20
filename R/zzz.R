
.KIS_TRADING_ENV <- NULL
.onLoad <- function(libname, pkgname){
  .KIS_TRADING_ENV <<- new.env()
  assign(".KIS_PAPER_BASE_URL", "https://openapivts.koreainvestment.com:29443", envir = .KIS_TRADING_ENV)
  assign(".KIS_BASE_URL", "https://openapi.koreainvestment.com:9443", envir = .KIS_TRADING_ENV)
  assign(".IS_PAPER", FALSE, envir = .KIS_TRADING_ENV)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Please get your KIS app key and secret from the website ",
    cli::style_hyperlink(
      text = "https://apiportal.koreainvestment.com/",
      url = "https://apiportal.koreainvestment.com/"
    )
  )
}

