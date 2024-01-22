#' @title get account balance
#'
#' @description
#' Get your account balance.
#'
#' @param prdt_code A string specifying account product code
#' @param rt_cash_flag A boolean specifying total deposit or not
#'
#' @return balance data.frame
#'
#' @examples
#' ## get account balance
#' \dontrun{
#' # detail
#' get_balance(rt_cash_flag = FALSE)
#' # total deposit
#' get_balance(rt_cash_flag = TRUE)}
#'
#' @export
get_balance <- function(prdt_code, rt_cash_flag = FALSE) {
  api_url <- "uapi/domestic-stock/v1/trading/inquire-balance"
  tr_id <- "TTTC8434R"

  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = prdt_code,
    "AFHR_FLPR_YN" = "N",
    "FNCG_AMT_AUTO_RDPT_YN" = "N",
    "FUND_STTL_ICLD_YN" = "N",
    "INQR_DVSN" = "01",
    "OFL_YN" = "N",
    "PRCS_DVSN" = "01",
    "UNPR_DVSN" = "01",
    "CTX_AREA_FK100" = "",
    "CTX_AREA_NK100" = ""
  )

  res <- url_fetch(api_url = api_url, tr_id = tr_id, params, post_flag = FALSE)
  resp <- res |> resp_body_json()

  if (res$status_code == 200) {
    if (resp$rt_cd == "0") {
      if (rt_cash_flag) {
        return(as.numeric(resp$output2[[1L]]$dnca_tot_amt))
      } else {
        df <- data.frame(data.table::rbindlist(resp$output1))
        if (nrow(df) > 0) {
          cols <- c("prdt_name","hldg_qty", "ord_psbl_qty", "pchs_avg_pric", "evlu_pfls_rt", "prpr", "bfdy_cprs_icdc", "fltt_rt")
          df <- df[, cols, drop = FALSE]
          df[, -1] <- lapply(df[, -1], as.numeric)
        }
        return(df)
      }
    } else if (resp$msg_cd == "EGW00123") {
      set_auth()
      get_balance()
    } else {
      cat(sprintf("%s %s %s\n", resp$rt_cd, resp$msg_cd, resp$msg1))
    }
  } else {
    cat(sprintf("Error Code : %s\n", res$status_code))
  }
}
