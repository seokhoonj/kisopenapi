
#' @title set authentification
#'
#' @description
#' Get access token using kis api key and kis api secret.
#'
#' @examples
#' # set authentification
#' \dontrun{set_auth()}
#'
#' @export
set_auth <- function() {
  url_base <- "https://openapi.koreainvestment.com:9443"
  path <- "uapi/domestic-stock/v1/quotations/inquire-price"
  headers <- list("content-type" = "application/json")
  body <- list(
    "grant_type" = "client_credentials",
    "appkey" = get_kis_api_key(),
    "appsecret" = get_kis_api_secret()
  )
  path <- "oauth2/tokenP"
  url <- sprintf("%s/%s", url_base, path)
  res <- request(url) |> req_headers(headers = headers) |>
    req_body_json(body) |> req_perform() |> resp_body_json()
  Sys.setenv(KIS_ACCESS_TOKEN = res$access_token)
  return(res)
}

##' @export
##' @rdname set_auth
get_auth <- function() {
  access_token <- Sys.getenv("KIS_ACCESS_TOKEN")
  if (access_token == "") {
    stop("Please run this code to provide your KIS access token: set_secret('your_access_token').",
         call. = FALSE)
  }
  return(access_token)
}

##' @export
##' @rdname set_auth
print_auth <- function() {
  Sys.getenv("KIS_ACCESS_TOKEN")
}
