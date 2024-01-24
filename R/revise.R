#' @title KIS revise and cancel orders
#'
#' @description
#' Revise and cancel orders.
#'
#' @param order_no A string specifying order number
#' @param order_branch A string specifying branch code
#' @param order_qty A numeric or string specifying order quantity
#' @param order_price A numeric or string specifying order price
#' @param prdt_code A string specifying account product code
#' @param order_dv A string specifying limit order(00) or market order(01)
#' @param cncl_dv A string specifying revise(01) or cancel(02)
#' @param qty_all_yn A string specifying total order quantity or not
#' @return A list contains rt_cd: return code, msg_cd: message code,
#' msg1: message
#'
#' @examples
#' ## revise
#' \dontrun{
#' kis_revise(
#'   order_no = "your order number",
#'   order_branch = "your order branch", order_qty = "your order quantity",
#'   order_price = "your order price"
#' )
#' }
#' ## cancel
#' \dontrun{
#' kis_cancel(
#'   order_no = "your order number",
#'   order_branch = "your order branch", order_qty = "your order quantity",
#'   order_price = "your order price"
#' )
#' }
#' ## cancel all
#' \dontrun{
#' kis_cancel_all()
#' }
#'
#' @return response
kis_revise_cancel <- function(order_no, order_branch, order_qty, order_price,
                              prdt_code, order_dv = "00",
                              cncl_dv = c("01", "02"),
                              qty_all_yn = c("Y", "N")) {
  api_url <- "uapi/domestic-stock/v1/trading/order-rvsecncl"
  tr_id <- "TTTC0803U"

  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- lapply(list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = get_acnt_prdt_cd(),
    "KRX_FWDG_ORD_ORGNO" = order_branch, # ord_gno_brno column
    "ORGN_ODNO" = order_no, # odno column
    "ORD_DVSN" = order_dv, # LIMIT ORDER (00), MARKET ORDER (01)
    "RVSE_CNCL_DVSN_CD" = cncl_dv[[1L]], # REVISE (01), CANCEL(02)
    "ORD_QTY" = order_qty,
    "ORD_UNPR" = order_price,
    "QTY_ALL_ORD_YN" = qty_all_yn[[1L]]
  ), as.character)

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params = params,
                   post_flag = TRUE, hash_flag = TRUE)
  resp <- res |> resp_body_json()

  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      return(resp)
    } else if (resp$msg1 == "EGW00123") {
      set_auth()
      kis_revise_cancel(
        order_no = order_no, order_branch = order_branch, order_qty = order_qty,
        order_price = order_price, prdt_code = prdt_code, order_dv = order_dv,
        cncl_dv = cncl_dv, qty_all_yn = qty_all_yn
      )
    } else {
      return(resp)
    }
  } else {
    return(res$status_code)
  }
}

#' @rdname kis_revise_cancel
#' @export
kis_revise <- function(order_no, order_branch, order_qty, order_price,
                       prdt_code, order_dv = "00", cncl_dv = "01",
                       qty_all_yn = c("Y", "N")) {
  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()
  kis_revise_cancel(
    order_no = order_no,
    order_branch = order_branch,
    order_qty = order_qty,
    order_price = order_price,
    prdt_code = prdt_code,
    order_dv = order_dv,
    cncl_dv = cncl_dv,
    qty_all_yn = qty_all_yn[[1L]]
  )
}

#' @rdname kis_revise_cancel
#' @export
kis_cancel <- function(order_no, order_branch, order_qty, order_price,
                       prdt_code, order_dv = "00", cncl_dv = "02",
                       qty_all_yn = c("Y", "N")) {
  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()
  kis_revise_cancel(
    order_no = order_no,
    order_branch = order_branch,
    order_qty = order_qty,
    order_price = order_price,
    prdt_code = prdt_code,
    order_dv = order_dv,
    cncl_dv = cncl_dv,
    qty_all_yn = qty_all_yn[[1L]]
  )
}

#' @rdname kis_revise_cancel
#' @export
kis_cancel_all <- function() {
  orders <- get_orders()
  if (inherits(orders, "data.frame")) {
    n <- nrow(orders)
    if (n > 0) {
      order_list <- as.numeric(orders$odno)
      qty_list <- orders$ord_qty
      price_list <- orders$ord_unpr
      branch_list <- orders$ord_gno_brno
      for (i in seq_len(n)) {
        kis_cancel(order_list[i], qty_list[i], price_list[i], branch_list[i])
        Sys.sleep(.2)
      }
    }
  } else {
    return(orders)
  }
}
