
generate_auth <- function() {
  base_url <- get_base_url()
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

  is_paper <- is_paper_trading()
  if (!is_paper) {
    Sys.setenv("KIS_ACCESS_TOKEN" = resp$access_token)
    Sys.setenv("KIS_ACCESS_TOKEN_EXPIRED" = resp$access_token_token_expired)
  } else {
    Sys.setenv("KIS_PAPER_ACCESS_TOKEN" = resp$access_token)
    Sys.setenv("KIS_PAPER_ACCESS_TOKEN_EXPIRED" = resp$access_token_token_expired)
  }
  return(resp$access_token)
}

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

url_fetch <- function(api_url, tr_id, params, append_headers, post_flag = FALSE,
                      hash_flag = TRUE, is_paper = FALSE) {
  base_url <- get_base_url()
  url <- sprintf("%s/%s", base_url = base_url, api_url = api_url)

  is_paper <- is_paper_trading()
  if (is_paper) {
    if (substr(tr_id, 1, 1) %in% c("T", "J", "C")) {
      tr_id <- sprintf("V%s", substr(tr_id, 2, nchar(tr_id)))
    }
  }

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
