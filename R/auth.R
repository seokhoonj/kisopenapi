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
  base_url <- "https://openapi.koreainvestment.com:9443"
  api_url <- "oauth2/tokenP"
  url <- sprintf("%s/%s", base_url, api_url)
  headers <- list("content-type" = "application/json")
  params <- list(
    "grant_type" = "client_credentials",
    "appkey" = get_app_key(),
    "appsecret" = get_app_secret()
  )
  res <- request(url) |> req_headers(headers = headers) |>
    req_body_json(params) |> req_perform()
  resp <- res |> resp_body_json()
  Sys.setenv(KIS_ACCESS_TOKEN = resp$access_token)
  Sys.setenv(KIS_ACCESS_TOKEN_EXPIRED = resp$access_token_token_expired)
  return(resp$access_token)
}

##' @export
##' @rdname set_auth
get_auth <- function() {
  access_token <- Sys.getenv("KIS_ACCESS_TOKEN")
  access_token_expired <- Sys.getenv("KIS_ACCESS_TOKEN_EXPIRED")
  if (access_token == "" | access_token_expired == "") {
    stop("Please run this code to provide your KIS access token: set_auth().",
         call. = FALSE)
  }
  if (as.POSIXct(access_token_expired) - Sys.time() < 0) {
    set_auth()
  }
  return(access_token)
}

##' @export
##' @rdname set_auth
print_auth <- function() {
  Sys.getenv("KIS_ACCESS_TOKEN")
}
