#' @title Set KIS account number, account product code, app key and app secret
#'
#' @description
#' Save environment variables for the current session. To set it permanently, \cr
#' please add the following line to your .Renvrion file: \cr
#'
#' # For live trading
#' KIS_CANO="YOUR ACCOUNT NUMBER" (first 8 digits of your account) \cr
#' KIS_ACNT_PRDT_CD="01" (last 2 digits of your account) \cr
#' KIS_APP_KEY="YOUR APP KEY" \cr
#' KIS_APP_SECRET="YOUR APP SECRET"
#' # For paper trading
#' KIS_PAPER_CANO="YOUR PAPER ACCOUNT NUMBER" (first 8 digits of your paper account) \cr
#' KIS_PAPER_ACNT_PRDT_CD="01" (last 2 digits of your paper account) \cr
#' KIS_PAPER_APP_KEY="YOUR PAPER APP KEY" \cr
#' KIS_PAPER_APP_SECRET="YOUR PAPER APP SECRET"
#'
#' @param cano A string specifying KIS common account number
#' @param acnt_prdt_cd A string specifying KIS account product code
#' @param app_key A string specifying KIS app key
#' @param app_secret A string specifying KIS app secret
#' @param is_paper A string specifying paper trading or not, default `FALSE`
#' @return No return value, called to set environment variables
#'
#' @examples
#' ## Set app key for the current session
#' \dontrun{
#' ## Set trading environment only for the current session
#' set_trading_env(
#'   cano = "your account number",
#'   acnt_prdt_no = "your account product code",
#'   app_key = "your app key",
#'   app_secret = "your app secret"
#' )
#' ## Check environment variables
#' print_cano()
#' print_acnt_prdt_cd()
#' print_app_key()
#' print_app_secret()}
#'
#' @export
set_trading_env <- function(cano, acnt_prdt_cd, app_key, app_secret,
                            is_paper = FALSE) {
  if (!is_paper) {
    Sys.setenv("KIS_CANO" = cano)
    Sys.setenv("KIS_ACNT_PRDT_CD" = acnt_prdt_cd)
    Sys.setenv("KIS_APP_KEY" = app_key)
    Sys.setenv("KIS_APP_SECRET" = app_secret)
  } else {
    Sys.setenv("KIS_PAPER_CANO" = cano)
    Sys.setenv("KIS_PAPER_ACNT_PRDT_CD" = acnt_prdt_cd)
    Sys.setenv("KIS_PAPER_APP_KEY" = app_key)
    Sys.setenv("KIS_PAPER_APP_SECRET" = app_secret)
  }
}

change_is_paper <- function() {
  assign(".IS_PAPER", !.KIS_TRADING_ENV$.IS_PAPER, envir = .KIS_TRADING_ENV)
}

is_paper_trading <- function() {
  return(local(.IS_PAPER, envir = .KIS_TRADING_ENV))
}

#' @title change trading environment
#'
#' @description
#' if you wrote live trading and paper trading evironment variables both in
#' your .Renviron file, you can change trading environment.
#'
#' @return "live" or "paper" string value
#'
#' @examples
#' \dontrun{change_trading_environment()}
#'
#' @export
change_trading_env <- function() {
  change_is_paper()
  is_paper <- is_paper_trading()
  if (!is_paper)
    return("live")
  else
    return("paper")
}

#' @title print trading environment
#'
#' @description
#' Print the current trading environment.
#'
#' @return "live" or "paper" string value
#'
#' @examples
#' \dontrun{print_trading_env()}
#'
#' @export
print_trading_env <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper)
    return("livr")
  else
    return("paper")
}

#' @title print base url
#'
#' @description
#' Print your base url in the current trading environemnt.
#' it changes depending on the trading environment.
#'
#' @return base url of current trading environment
#'
#' @examples
#' \dontrun{print_base_url()}
#'
#' @export
print_base_url <- function() {
  get_base_url()
}

#' @title print account number
#'
#' @description
#' Print your account number in the current trading environemnt.
#' it changes depending on the trading environment.
#'
#' @return account number
#'
#' @examples
#' \dontrun{print_cano()}
#'
#' @export
print_cano <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    cano <- Sys.getenv("KIS_CANO")
  } else {
    cano <- Sys.getenv("KIS_CANO_PAPER")
  }
  return(cano)
}

#' @title print account product code
#'
#' @description
#' Print your account product code in the current trading environemnt.
#' it changes depending on the trading environment.
#'
#' @return account product code
#'
#' @examples
#' \dontrun{print_acnt_prdt_cd()}
#'
#' @export
print_acnt_prdt_cd <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    acnt_prdt_cd <- Sys.getenv("KIS_ACNT_PRDT_CD")
  } else {
    acnt_prdt_cd <- Sys.getenv("KIS_PAPER_ACNT_PRDT_CD")
  }
  return(acnt_prdt_cd)
}

#' @title print app key
#'
#' @description
#' Print your app key in the current trading environemnt.
#' it changes depending on the trading environment.
#'
#' @return app key
#'
#' @examples
#' \dontrun{print_app_key()}
#'
#' @export
print_app_key <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    app_key <- Sys.getenv("KIS_APP_KEY")
  } else {
    app_key <- Sys.getenv("KIS_PAPER_APP_KEY")
  }
  return(app_key)
}

#' @title print app secret
#'
#' @description
#' Print your app secret in the current trading environemnt.
#' it changes depending on the trading environment.
#'
#' @return app secret
#'
#' @examples
#' \dontrun{print_app_secret()}
#'
#' @export
print_app_secret <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    app_secret <- Sys.getenv("KIS_APP_SECRET")
  } else {
    app_secret <- Sys.getenv("KIS_PAPER_APP_SECRET")
  }
  return(app_secret)
}

get_base_url <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    base_url <- local(.KIS_BASE_URL, envir = .KIS_TRADING_ENV)
  } else {
    base_url <- local(.KIS_PAPER_BASE_URL, envir = .KIS_TRADING_ENV)
  }
  return(base_url)
}

get_cano <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    cano <- Sys.getenv("KIS_CANO")
  } else {
    cano <- Sys.getenv("KIS_PAPER_CANO")
  }
  if (cano == "") {
    stop("Please provide your KIS_CANO='' or KIS_PAPER_CANO='' to .Reviron",
         call. = FALSE)
  }
  return(cano)
}

get_acnt_prdt_cd <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    acnt_prdt_cd <- Sys.getenv("KIS_ACNT_PRDT_CD")
  } else {
    acnt_prdt_cd <- Sys.getenv("KIS_PAPER_ACNT_PRDT_CD")
  }
  if (acnt_prdt_cd == "") {
    stop("Please provide your KIS_ACNT_PRDT_CD='' or KIS_PAPER_ACNT_PRDT_CD='' to .Reviron",
         call. = FALSE)
  }
  return(acnt_prdt_cd)
}

get_app_key <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    app_key <- Sys.getenv("KIS_APP_KEY")
  } else {
    app_key <- Sys.getenv("KIS_PAPER_APP_KEY")
  }
  if (app_key == "") {
    stop("Please provide your KIS_APP_KEY='' or KIS_PAPER_APP_KEY='' to .Reviron",
         call. = FALSE)
  }
  return(app_key)
}

get_app_secret <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    app_secret <- Sys.getenv("KIS_APP_SECRET")
  } else {
    app_secret <- Sys.getenv("KIS_PAPER_APP_SECRET")
  }
  if (app_secret == "") {
    stop("Please provide your KIS_APP_SECRET='' or KIS_PAPER_APP_SECRET='' to .Reviron",
         call. = FALSE)
  }
  return(app_secret)
}
