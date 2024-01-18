#' @title get account balance
#'
#' @description
#' Get your account balance
#'
#' @param prdt_code A string specifying account product code
#'
#' @return balance data.frame
#'
#' @export
get_balance <- function(prdt_code) {
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
      return(data.frame(resp$output2[[1L]]))
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
