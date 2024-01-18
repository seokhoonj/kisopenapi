##' @title Set KIS common account number
##'
##' @description
##' Save KIS common account number for the current session. To set it permanently,
##' please add the following line to your .Renvrion file:
##'
##' KIS_CANO = "YOUR COMMON ACCOUNT NUMBER" (first 8 digits)
##'
##' @param cano A string specifying KIS common account number
##' @return No return value, called to set KIS common account number
##' @examples
##'
##' ## Set API Key for the current session
##' \donttest{set_cano("your_common_account_number")}
##'
##' ## Check common account number
##' print_cano()
##'
##' @export
set_cano <- function(cano) {
  Sys.setenv(KIS_CANO = cano)
}

##' @export
##' @rdname set_cano
get_cano <- function() {
  cano <- Sys.getenv("KIS_CANO")
  if (cano == "") {
    stop("Please run this code to provide your KIS common account number: set_cano('your_common_account_number') (first 8 digits).",
         call. = FALSE)
  }
  return(cano)
}

##' @export
##' @rdname set_cano
print_cano <- function() {
  Sys.getenv("KIS_CANO")
}

##' @title Set KIS account product code
##'
##' @description
##' Save KIS account product code for the current session. To set it permanently,
##' please add the following line to your .Renvrion file:
##'
##' KIS_ACNT_PRDT_CD = "YOUR ACCOUNT PRODUCT CODE" (last 2 digits)
##'
##' @param acnt_prdt_cd A string specifying KIS account product code
##' @return No return value, called to set KIS account product code
##' @examples
##'
##' ## Set API secret for the current session
##' \donttest{set_acnt_prdt_cd("your_acnt_prdt_cd")}
##'
##' ## Check API secret
##' print_acnt_prdt_cd()
##'
##' @export
set_acnt_prdt_cd <- function(acnt_prdt_cd) {
  Sys.setenv(KIS_ACNT_PRDT_CD = acnt_prdt_cd)
}

##' @export
##' @rdname set_acnt_prdt_cd
get_acnt_prdt_cd <- function() {
  acnt_prdt_cd <- Sys.getenv("KIS_ACNT_PRDT_CD")
  if (acnt_prdt_cd == "") {
    stop("Please run this code to provide your KIS account product code: set_acnt_prdt_cd('your_acnt_prdt_cd') (last 2 digits).",
         call. = FALSE)
  }
  return(acnt_prdt_cd)
}

##' @export
##' @rdname set_acnt_prdt_cd
print_acnt_prdt_cd <- function() {
  Sys.getenv("KIS_ACNT_PRDT_CD")
}
