#' @description
#' To use this package, you will first need to get your API key and secret from
#' the website \url{https://apiportal.koreainvestment.com/}. Once you have your
#' key and secret, you can save those as environment variables for the current
#' session using the \code{\link{set_kis_api_key}}, \code{\link{set_kis_api_secret}}
#' function. Alternatively, you can set those permanently by adding the
#' following line to your .Renviron file:
#' KIS_API_KEY = PASTE YOUR API KEY
#' KIS_API_SECRET = PASTE YOUR API SECRET
#' Any functions that require your API key and secret try to retrieve those via
#' \code{Sys.getenv("KIS_API_KEY")}, \code{Sys.getenv("KIS_API_SECRET")}
#' (unless API key and secret are explicitly specified as function arguments).
#' @keywords internal
#' @importFrom httr2 req_body_json req_error req_headers req_perform
#'  req_url_query request resp_body_json
#' @importFrom jsonlite toJSON
#' @importFrom utils head tail
"_PACKAGE"
