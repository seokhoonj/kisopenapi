#' @title KIS order
#'
#' @description
#' Order stock using KIS API
#'
#' @param stock_code A string specifying stock code
#' @param order_qty A numeric or string specifying order quantity
#' @param order_price A numeric or string specifying order price
#' @param buy_flag A boolean specifying flag
#' @param order_type A string specifying order type
#'
#' @return An order result
kis_order <- function(stock_code, order_qty, order_price, order_type = "00",
                      buy_flag = TRUE) {
  api_url <- "uapi/domestic-stock/v1/trading/order-cash"
  tr_id <- if (buy_flag) "TTTC0802U" else "TTTC0801U"

  params <- lapply(list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = get_acnt_prdt_cd(),
    "PDNO" = stock_code,
    "ORD_DVSN" = order_type,
    "ORD_QTY" = order_qty,
    "ORD_UNPR" = order_price,
    "CTAC_TLNO" =  "",
    "SLL_TYPE" =  "01",
    "ALGO_NO" = ""
  ), as.character)

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params,
                   post_flag = TRUE, hash_flag = TRUE)
  resp <- res |> resp_body_json()
  return(resp)
}

#' @rdname kis_order
#' @export
kis_buy <- function(stock_code, order_qty, order_price, order_type = "00") {
  kis_order(
    stock_code = stock_code, order_qty = order_qty, order_price = order_price,
    order_type = order_type, buy_flag = TRUE
  )
}

#' @rdname kis_order
#' @export
kis_sell <- function(stock_code, order_qty, order_price, order_type = "00") {
  kis_order(
    stock_code = stock_code, order_qty = order_qty, order_price = order_price,
    order_type = order_type, buy_flag = FALSE
  )
}

#' @title get orders
#'
#' @description
#' Return a list of orders that can be modified or canceled.
#'
#' @return data.frame of orders
#'
#' @examples
#' # get a list of orders
#' \dontrun{get_orders()}
#'
#' @export
get_orders <- function() {
  api_url <- "uapi/domestic-stock/v1/trading/inquire-psbl-rvsecncl"
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

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params,
                   hash_flag = TRUE)

  resp <- res |> resp_body_json()
  return(data.table::rbindlist(resp$output))
}
