#' @title get current price
#'
#' @description
#' Get current stock price using KIS API.
#'
#' @param stock_code A string specifying stock number (stock code)
#' @return current stock price
#'
#' @examples
#' ## get current price
#' \dontrun{get_current_price("005930")}
#'
#' @export
get_current_price <- function(stock_code) {
  api_url <- "uapi/domestic-stock/v1/quotations/inquire-price"
  tr_id <- "FHKST01010100"
  params <- list(
    "fid_cond_mrkt_div_code" = "J",
    "fid_input_iscd" = stock_code
  )
  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params)
  resp <- res |> resp_body_json()
  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      return(data.frame(resp$output))
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_current_price(stock_code)
    } else {
      cat(sprintf("%s %s %s\n", resp$rt_cd, resp$msg_cd, resp$msg1))
    }
  } else {
    cat(sprintf("Error Code : %s\n", res$status_code))
  }
}

#' @title get stock history
#'
#' @description
#' Get stock history using KIS API.
#'
#' @param stock_code A string specifying stock code
#' @param unit A string specifying day, week, month
#' @return stock history data frame
#'
#' @examples
#' ## get stock history
#' \dontrun{get_stock_history("005930")}
#'
#' @export
get_stock_history <- function(stock_code, unit = c("D", "W", "M")) {
  api_url <- "uapi/domestic-stock/v1/quotations/inquire-daily-price"
  tr_id <- "FHKST01010400"

  params <- list(
    "fid_cond_mrkt_div_code" = "J",
    "fid_input_iscd" = stock_code,
    "fid_org_adj_prc" = "0",
    "fid_period_div_code" = unit[1L]
  )

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params)
  resp <- res |> resp_body_json()

  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      return(as.data.frame(data.table::rbindlist(resp$output)))
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_stock_history(stock_code)
    } else {
      cat(sprintf("%s %s %s\n", resp$rt_cd, resp$msg_cd, resp$msg1))
    }
  } else {
    cat(sprintf("Error Code : %s\n", res$status_code))
  }
}

#' @title get stock investor
#'
#' @description
#' Get stock investor data using KIS API.
#'
#' @param stock_code A string specifying stock code
#' @return stock investor data frame
#'
#' @examples
#' ## get stock investor
#' \dontrun{get_stock_investor("005930")}
#'
#' @export
get_stock_investor <- function(stock_code) {
  api_url <- "uapi/domestic-stock/v1/quotations/inquire-investor"
  tr_id <- "FHKST01010900"

  params <- list(
    "FID_COND_MRKT_DIV_CODE" = "J",
    "FID_INPUT_ISCD" = stock_code
  )

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params)
  resp <- res |> resp_body_json()

  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      return(data.frame(data.table::rbindlist(resp$output)))
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_stock_investor(stock_code)
    } else {
      cat(sprintf("%s %s %s\n", resp$rt_cd, resp$msg_cd, resp$msg1))
    }
  } else {
    cat(sprintf("Error Code : %s\n", res$status_code))
  }
}
