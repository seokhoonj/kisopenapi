#' @title get current price
#'
#' @description
#' Get current stock price.
#'
#' @param stock_code A string specifying stock number (stock code)
#' @return current stock price
#'
#' @examples
#' # get current price
#' \dontrun{
#' get_current_price("005930")
#' }
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
      return(resp)
    }
  } else {
    return(res$status_code)
  }
}

#' @title get stock quotes
#'
#' @description
#' Get current stock qutoes.
#'
#' @param stock_code A string specifying stock code
#' @return current stock quotes data frame
#'
#' @examples
#' # get stock quotes
#' \dontrun{
#' get_stock_quotes("005930")
#' }
#'
#' @export
get_stock_quotes <- function(stock_code) {
  # get_stock_completed function at kis official git repo
  api_url <- "uapi/domestic-stock/v1/quotations/inquire-ccnl"
  tr_id <- "FHKST01010300"

  params <- lapply(list(
    "FID_COND_MRKT_DIV_CODE" = "J",
    "FID_INPUT_ISCD" = stock_code
  ), as.character)

  res <- url_fetch(api_url, tr_id, params)
  resp <- res |> resp_body_json()

  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      return(data.frame(data.table::rbindlist(resp$output)))
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_stock_quotes(stock_code)
    } else {
      return(resp)
    }
  } else {
    return(res$status_code)
  }
}

#' @title get stock history
#'
#' @description
#' Get stock history.
#'
#' @param stock_code A string specifying stock code
#' @param unit A string specifying day, week, month
#' @return stock history data frame
#'
#' @examples
#' # get stock history
#' \dontrun{
#' get_stock_history("005930")
#' }
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
      return(data.frame(data.table::rbindlist(resp$output)))
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_stock_history(stock_code)
    } else {
      return(resp)
    }
  } else {
    return(res$status_code)
  }
}

#' @title get stock history by ohlcv
#'
#' @description
#' Get stock history by open, high, low, close, volume.
#'
#' @param stock_code A string specifying stock code
#' @param unit A string specifying day, week, month
#' @param add_var A boolean adding volitility and percentage change
#' @return stock history by ohlcv data frame
#'
#' @examples
#' # get stock history
#' \dontrun{
#' get_stock_history_by_ohlcv("005930")
#' }
#'
#' @export
get_stock_history_by_ohlcv <- function(stock_code, unit = "D",
                                       add_var = FALSE) {
  df <- get_stock_history(stock_code, unit = unit)
  if (nrow(df) > 0) {
    chosend_fld <- c("stck_bsop_date", "stck_oprc", "stck_hgpr", "stck_lwpr",
                     "stck_clpr", "acml_vol")
    renamed_fld <- c("date", "open", "high", "low", "close", "volume")
    df <- df[, chosend_fld, drop = FALSE]
    names(df) <- renamed_fld
    df[] <- lapply(df, as.numeric)
    df$date <- as.Date(as.character(df$date), "%Y%m%d")
    if (add_var) {
      df$inter_volatile <- (df$high - df$low) / df$close
      df$pct_change <- (df$close - data.table::shift(df$close, n = -1)) /
        data.table::shift(df$close, n = -1) * 100
    }
  }
  return(df)
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
#' # get stock investor
#' \dontrun{
#' get_stock_investor("005930")
#' }
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
      df <- data.frame(data.table::rbindlist(resp$output))
      if (nrow(df) > 0) {
        chosend_fld <- c("stck_bsop_date", "prsn_ntby_qty", "frgn_ntby_qty",
                         "orgn_ntby_qty")
        renamed_fld <- c("date", "perbuy", "forbuy", "orgbuy")
        df <- df[, chosend_fld, drop = FALSE]
        names(df) <- renamed_fld
        df[] <- lapply(df, as.numeric)
        df$date <- as.Date(as.character(df$date), "%Y%m%d")
        df$etcbuy <- (df$perbuy + df$forbuy + df$orgbuy) * -1
      }
      return(df)
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_stock_investor(stock_code)
    } else {
      return(resp)
    }
  } else {
    return(res$status_code)
  }
}
