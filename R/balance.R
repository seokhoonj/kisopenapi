#' @title get account balance
#'
#' @description
#' Get your account balance
#'
#' @return balance data.frame
#'
#' @export
get_balance <- function() {
  api_url <- "uapi/domestic-stock/v1/trading/inquire-balance"
  tr_id <- "TTTC8434R"

  params <- list(
    "CANO" = get_cano(),
    "ACNT_PRDT_CD" = get_acnt_prdt_cd(),
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
  return(data.table::data.table(resp$output2[[1L]]))
}
