#' @title get account balance
#'
#' @description
#' Get your account balance.
#'
#' @param prdt_code A string specifying account product code
#' @param rt_cash_flag A boolean specifying deposit or details
#'
#' @return balance data.frame
#'
#' @examples
#' ## get account balance
#' \dontrun{
#' # details
#' get_balance(rt_cash_flag = FALSE)
#' # deposit
#' get_balance(rt_cash_flag = TRUE)}
#'
#' @export
get_balance <- function(prdt_code, rt_cash_flag = FALSE) {
  api_url <- "/uapi/domestic-stock/v1/trading/inquire-balance"
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

  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params, post_flag = FALSE)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      if (rt_cash_flag) {
        return(as.numeric(res$output2[[1L]]$dnca_tot_amt))
      } else {
        df <- data.frame(data.table::rbindlist(res$output1))
        if (nrow(df) > 0) {
          cols <- c(
            "pdno", "prdt_name", "hldg_qty", "ord_psbl_qty", "pchs_avg_pric",
            "pchs_amt", "prpr", "evlu_amt", "evlu_pfls_amt", "evlu_pfls_rt",
            "fltt_rt", "bfdy_cprs_icdc"
          )
          df <- df[, cols, drop = FALSE]
          df[, -c(1:2)] <- lapply(df[, -c(1:2)], as.numeric)
        }
        return(df)
      }
    } else if (res$msg_cd == "EGW00123") {
      set_auth()
      get_balance()
    } else {
      cat(sprintf("%s %s %s\n", res$rt_cd, res$msg_cd, res$msg1))
    }
  } else {
    cat(sprintf("Error Code : %s\n", resp$status_code))
  }
}

get_account <- function(prdt_code) {
  api_url <- "/uapi/domestic-stock/v1/trading/inquire-account-balance"
  tr_id <- "CTRP6548R"

  if (missing(prdt_code))
    prdt_code <- get_acnt_prdt_cd()

  params <- list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = prdt_code,
    "INQR_DVSN_1" = "",
    "BSPR_BF_DT_APLY_YN" = ""
  )

  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params, post_flag = FALSE)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      df <- data.frame(res$output2)
      df[] <- lapply(df, as.numeric)
      return(df)
    } else if (res$msg_cd == "EGW00123") {
      set_auth()
      get_account()
    } else {
      return(res)
    }
  } else {
    return(resp$status_code)
  }

}
