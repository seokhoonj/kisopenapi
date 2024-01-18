#' @title set access token
#'
#' @description
#' Set access token using kis app key and kis app secret.
#'
#' @examples
#' # set authentification
#' \dontrun{set_auth()}
#'
#' @export
set_auth <- function() {
  access_token <- Sys.getenv("KIS_ACCESS_TOKEN")
  access_token_expired <- Sys.getenv("KIS_ACCESS_TOKEN_EXPIRED")
  if (access_token == "") {
    generate_auth()
  } else {
    if (access_token_expired == "") {
      generate_auth()
    } else if ((as.POSIXct(access_token_expired) - Sys.time()) < 0) {
      generate_auth()
    } else {
      return(access_token)
    }
  }
}

##' @rdname set_auth
##' @export
get_auth <- function() set_auth()


##' @rdname set_auth
##' @export
print_auth <- function() {
  Sys.getenv("KIS_ACCESS_TOKEN")
}
