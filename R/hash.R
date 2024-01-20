#' @title get hash key
#'
#' @description
#' Get hash key using KIS app key and KIS app secret.
#'
#' @param params A string specifying params
#' @return A string hash value
#'
#' @examples
#' # get hash key
#' \dontrun{get_hash(params)}
#'
#' @export
get_hash <- function(params) {
  base_url <- get_base_url()
  api_url <- "uapi/hashkey"
  url <- sprintf("%s/%s", base_url, api_url)
  headers <- list(
    "Content-Type" = "application/json",
    "appKey" = get_app_key(),
    "appSecret" = get_app_secret()
  )
  res <- request(url) |> req_headers(!!!headers) |>
    req_body_json(params) |> req_perform()
  resp <- res |> resp_body_json()
  hash <- resp$HASH
  return(hash)
}
