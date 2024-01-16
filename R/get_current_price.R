
#' @title get current price
#'
#' @description
#' Get current stock price using KIS api.
#'
#' @param stock_no A string specifying stock number (stock code)
#' @return current stock price
#'
#' @examples
#' ## get current price
#' \dontrun{get_current_price()}
#'
#' @export
get_current_price <- function(stock_no) {
  url_base <- "https://openapi.koreainvestment.com:9443"
  path <- "uapi/domestic-stock/v1/quotations/inquire-price"
  url <- sprintf("%s/%s", url_base, path)
  headers <- list(
    "Content-Type" = "application/json",
    "authorization" = sprintf("Bearer %s", get_auth()),
    "appKey" = get_kis_api_key(),
    "appSecret" = get_kis_api_secret(),
    "tr_id" = "FHKST01010100"
  )
  params <- list(
    "fid_cond_mrkt_div_code" = "J",
    "fid_input_iscd" = stock_no
  )
  res <- request(url) |> req_headers(!!!headers) |> req_url_query(!!!params) |>
    req_perform() |> req_error()
  resp <- res |> resp_body_json()
  if (res$status_code == 200 & resp$rt_cd == "0") {
    return(resp)
  } else if (res$status_code == 200 & resp$msg_cd == "EGW00123") {
    set_auth()
    get_current_price(stock_no)
  } else {
    cat(sprintf("Error Code : %s\n", res$status_code))
  }
}
