##' @title Set KIS app key
##'
##' @description
##' Save KIS app key for the current session. To set it permanently, please add
##' the following line to your .Renvrion file:
##'
##' KIS_APP_KEY = "YOUR APP KEY"
##'
##' @param app_key A string specifying KIS app key
##' @return No return value, called to set KIS app key
##' @examples
##'
##' ## Set app key for the current session
##' \donttest{set_app_key("your_app_key")}
##'
##' ## Check app key
##' print_app_key()
##'
##' @export
set_app_key <- function(app_key) {
  Sys.setenv(KIS_APP_KEY = app_key)
}

##' @export
##' @rdname set_app_key
get_app_key <- function() {
  app_key <- Sys.getenv("KIS_APP_KEY")
  if (app_key == "") {
    stop("Please run this code to provide your KIS app key: set_key('your_app_key').",
         call. = FALSE)
  }
  return(app_key)
}

##' @export
##' @rdname set_app_key
print_app_key <- function() {
  Sys.getenv("KIS_APP_KEY")
}

##' @title Set KIS app secret
##'
##' @description
##' Save KIS app secret for the current session. To set it permanently, please add
##' the following line to your .Renvrion file:
##'
##' KIS_APP_SECRET = "YOUR APP SECRET"
##'
##' @param app_secret A string specifying KIS app secret
##' @return No return value, called to set KIS app secret
##' @examples
##'
##' ## Set app secret for the current session
##' \donttest{set_app_secret("your_app_secret")}
##'
##' ## Check app secret
##' print_app_secret()
##'
##' @export
set_app_secret <- function(app_secret) {
  Sys.setenv(KIS_APP_SECRET = app_secret)
}

##' @export
##' @rdname set_app_secret
get_app_secret <- function() {
  app_secret <- Sys.getenv("KIS_APP_SECRET")
  if (app_secret == "") {
    stop("Please run this code to provide your KIS app secret: set_secret('your_app_secret').",
         call. = FALSE)
  }
  return(app_secret)
}

##' @export
##' @rdname set_app_secret
print_app_secret <- function() {
  Sys.getenv("KIS_APP_SECRET")
}
