##' @title Set KIS api key
##'
##' @description
##' Save KIS api key for the current session. To set it permanently, please add
##' the following line to your .Renvrion file:
##'
##' KIS_API_KEY = "YOUR API KEY"
##'
##' @param api_key A string specifying KIS api key
##' @return No return value, called to set kis api key
##' @examples
##'
##' ## Set API Key for the current session
##' \donttest{set_kis_api_key("your_api_key")}
##'
##' ## Check API key
##' print_kis_api_key()
##'
##' @export
set_kis_api_key <- function(api_key) {
  Sys.setenv(KIS_API_KEY = api_key)
}

##' @export
##' @rdname set_kis_api_key
get_kis_api_key <- function() {
  api_key <- Sys.getenv("KIS_API_KEY")
  if (api_key == "") {
    stop("Please run this code to provide your KIS api key: set_key('your_api_key').",
         call. = FALSE)
  }
  return(api_key)
}

##' @export
##' @rdname set_kis_api_key
print_kis_api_key <- function() {
  Sys.getenv("KIS_API_KEY")
}

##' @title Set KIS api secret
##'
##' @description
##' Save KIS api secret for the current session. To set it permanently, please add
##' the following line to your .Renvrion file:
##'
##' KIS_API_SECRET = "YOUR API SECRET"
##'
##' @param api_secret A string specifying KIS api secret
##' @return No return value, called to set kis api secret
##' @examples
##'
##' ## Set API secret for the current session
##' \donttest{set_kis_api_secret("your_api_secret")}
##'
##' ## Check API secret
##' print_kis_api_secret()
##'
##' @export
set_kis_api_secret <- function(api_secret) {
  Sys.setenv(KIS_API_SECRET = api_secret)
}

##' @export
##' @rdname set_kis_api_secret
get_kis_api_secret <- function() {
  api_secret <- Sys.getenv("KIS_API_SECRET")
  if (api_secret == "") {
    stop("Please run this code to provide your KIS api secret: set_secret('your_api_secret').",
         call. = FALSE)
  }
  return(api_secret)
}

##' @export
##' @rdname set_kis_api_secret
print_kis_api_secret <- function() {
  Sys.getenv("KIS_API_SECRET")
}
