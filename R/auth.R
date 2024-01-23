#' @title set access token
#'
#' @description
#' Set access token (hash key) using kis app key and kis app secret.
#'
#' @return An access token (access token is stored in environment variable
#' at the same time)
#'
#' @examples
#' # set authentification
#' \dontrun{
#' set_auth()
#' }
#'
#' @export
set_auth <- function() {
  is_paper <- is_paper_trading()
  if (!is_paper) {
    access_token <- Sys.getenv("KIS_ACCESS_TOKEN")
    access_token_expired <- Sys.getenv("KIS_ACCESS_TOKEN_EXPIRED")
  } else {
    access_token <- Sys.getenv("KIS_PAPER_ACCESS_TOKEN")
    access_token_expired <- Sys.getenv("KIS_PAPER_ACCESS_TOKEN_EXPIRED")
  }
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
