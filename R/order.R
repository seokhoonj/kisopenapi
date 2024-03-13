#' KIS order
#'
#' Order stocks.
#'
#' @param stock_code A string specifying stock code
#' @param order_qty A numeric or string specifying order quantity
#' @param order_price A numeric or string specifying order price
#' @param prdt_code A string specifying account product code
#' @param order_type A string specifying order type
#' @param buy_flag A boolean specifying flag
#' @return A list contains rt_cd: return code, msg_cd: message code,
#' msg1: message
#'
#' @examples
#' \dontrun{
#' ## buy
#' kis_buy(
#'   stock_code = "stock code",
#'   order_qty = "your order quantity",
#'   order_price = "your order price"
#' )
#' ## sell
#' kis_sell(
#'   stock_code = "stock code",
#'   order_qty = "your order quantity",
#'   order_price = "your order price"
#' )
#' }
#'
#' @return An order result
kis_order <- function(stock_code, order_qty, order_price, prdt_code,
                      order_type = "00", buy_flag = TRUE) {
  api_url <- "/uapi/domestic-stock/v1/trading/order-cash"
  tr_id <- if (buy_flag) "TTTC0802U" else "TTTC0801U"

  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- lapply(list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = prdt_code,
    "PDNO" = stock_code,
    "ORD_DVSN" = order_type,
    "ORD_QTY" = order_qty,
    "ORD_UNPR" = order_price,
    "CTAC_TLNO" =  "",
    "SLL_TYPE" =  "01",
    "ALGO_NO" = ""
  ), as.character)

  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params = params,
                   post_flag = TRUE, hash_flag = TRUE)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      return(res)
    } else if (res$msg1 == "EGW00123") { # access token is expired.
      set_auth()
      kis_order(
        stock_code = stock_code, order_qty = order_qty,
        order_price = order_price, prdt_code = prdt_code,
        order_type = order_type, buy_flag = buy_flag
      )
    } else {
      raise_error(res)
    }
  } else {
    return(resp$status_code)
  }
}

#' @rdname kis_order
#' @export
kis_buy <- function(stock_code, order_qty, order_price, prdt_code,
                    order_type = "00") {
  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()
  kis_order(
    stock_code = stock_code, order_qty = order_qty, order_price = order_price,
    prdt_code = prdt_code, order_type = order_type, buy_flag = TRUE
  )
}

#' @rdname kis_order
#' @export
kis_sell <- function(stock_code, order_qty, order_price, prdt_code,
                     order_type = "00") {
  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()
  kis_order(
    stock_code = stock_code, order_qty = order_qty, order_price = order_price,
    prdt_code = prdt_code, order_type = order_type, buy_flag = FALSE
  )
}

#' @title get orders
#'
#' @description
#' Return a list of orders that can be revised or canceled.
#'
#' @return data.frame of orders
#'
#' @examples
#' # get a list of orders
#' \dontrun{
#' get_orders()
#' }
#'
#' @export
get_orders <- function() {
  api_url <- "/uapi/domestic-stock/v1/trading/inquire-psbl-rvsecncl"
  tr_id <- "TTTC8036R"

  params <- list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = get_acnt_prdt_cd(),
    "CTX_AREA_FK100" = "",
    "CTX_AREA_NK100" = "",
    "INQR_DVSN_1" = "0",
    "INQR_DVSN_2" = "0"
  )

  headers <- list(
    "Content-Type" = "application/json",
    "authorization" = sprintf("Bearer %s", get_auth()),
    "appKey" = get_app_key(),
    "appSecret" = get_app_secret(),
    "tr_id" = tr_id,
    "custtype" = "P",
    "hashkey" = get_hash(params)
  )

  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params = params,
                   hash_flag = TRUE)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      return(data.frame(data.table::rbindlist(res$output)))
    } else if (res$msg_cd == "EGW00123") {
      set_auth()
      get_orders()
    } else {
      return(res)
    }
  } else {
    return(resp$status_code)
  }
}

#' @title get order history
#'
#' @description
#' Get order history from start date to end date.
#'
#' @param sdt A string specifying start date "YYYYMMDD"
#' @param edt A string specifying end date "YYYYMMDD"
#' @param prdt_code A string specifying account product code
#' @param zip_flag A boolean specifying choosing important columns
#' @return Order history data frame
#'
#' @examples
#' # get order history
#' \dontrun{
#' get_order_history("20")
#' }
#'
#' @export
get_order_history <- function(sdt, edt, prdt_code, zip_flag = TRUE) {
  # get_my_complete function at kis official git repo
  api_url <- "/uapi/domestic-stock/v1/trading/inquire-daily-ccld"
  tr_id <- "TTTC8001R"

  if (missing(edt))
    edt <- format(Sys.Date(), "%Y%m%d")
  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- lapply(list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = prdt_code,
    "INQR_STRT_DT" = sdt,
    "INQR_END_DT" = edt,
    "SLL_BUY_DVSN_CD" = "00",
    "INQR_DVSN" = "00",
    "PDNO" = "",
    "CCLD_DVSN" = "00",
    "ORD_GNO_BRNO" = "",
    "ODNO" = "",
    "INQR_DVSN_3" = "00",
    "INQR_DVSN_1" = "",
    "INQR_DVSN_2" = "",
    "CTX_AREA_FK100" = "",
    "CTX_AREA_NK100" = ""
  ), as.character)

  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params = params)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      output <- data.frame(data.table::rbindlist(res$output1))
      if (zip_flag) {
        return(output[, c(
          "ord_dt", "orgn_odno", "sll_buy_dvsn_cd_name", "pdno", "ord_qty",
          "ord_unpr", "avg_prvs", "cncl_yn", "tot_ccld_amt", "rmn_qty"
        )])
      } else {
        return(output)
      }
    } else if (res$msg_cd == "EGW00123") { # access token is expired.
      set_auth()
      get_order_history()
    } else {
      return(resp)
    }
  } else {
    return(resp$status_code)
  }
}

#' @title get buyable cash
#'
#' @description
#' Get buyable amount of cash of the account
#'
#' @param prdt_code A string specifying account product code
#' @return A numeric specifying buyable cash
#'
#' @examples
#' # get buyable cash
#' \dontrun{
#' get_buyable_cash()
#' }
#'
#' @export
get_buyable_cash <- function(prdt_code) {
  api_url <- "/uapi/domestic-stock/v1/trading/inquire-daily-ccld"
  tr_id <- "TTTC8908R"

  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- lapply(list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = prdt_code,
    "PDNO" = "",
    "ORD_UNPR" = "0",
    "ORD_DVSN" = "02",
    "CMA_EVLU_AMT_ICLD_YN" = "Y",
    "OVRS_ICLD_YN" = "N"
  ), as.character)

  resp <- url_fetch(api_url, tr_id, params)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      return(as.numeric(res$output$ord_psbl_cash))
    } else if (res$msg_cd == "EGW00123") { # access token is expired.
      set_auth()
      get_buyable_cash()
    } else {
      return(res)
    }
  } else {
    return(resp$status_code)
  }
}
