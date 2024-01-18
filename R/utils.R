
generate_auth <- function() {
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

url_fetch <- function(api_url, tr_id, params, append_headers, post_flag = FALSE,
                      hash_flag = TRUE) {
  base_url <- "https://openapi.koreainvestment.com:9443"
  url <- sprintf("%s/%s", base_url, api_url)

  headers <- list(
    "Content-Type" = "application/json",
    "Accept" = "text/plain",
    "charset" = "UTF-8",
    "User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  )
  headers[["authorization"]] <- sprintf("Bearer %s", get_auth())
  headers[["appKey"]] <- get_app_key()
  headers[["appSecret"]] <- get_app_secret()
  headers[["tr_id"]] <- tr_id
  headers[["custtype"]] <- "P"

  if (!missing(append_headers)) {
    headers <- append(headers, append_headers)
  }

  if (post_flag) {
    if (hash_flag) {
      hashkey <- c(hashkey = get_hash(params))
      headers <- append(headers, hashkey)
    }
    res <- request(url) |> req_headers(!!!headers) |>
      req_body_json(params) |> req_perform()
  } else {
    res <- request(url) |> req_headers(!!!headers) |>
      req_url_query(!!!params) |> req_perform()
  }
  return(res)
}
