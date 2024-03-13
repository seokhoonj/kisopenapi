#' @title get current index
#'
#' @description
#' Get current index.
#'
#' @param index_code A string specifying an index code (KOSPI: "0001", KOSDAQ: "1001", KOSPI200: "2001")
#' @return a data frame of current index
#'
#' @examples
#' # get current index
#' \dontrun{
#' get_current_index("0001")
#' }
#'
#' @export
get_current_index <- function(index_code = c("0001", "1001", "2001")) {
  index_code <- match.arg(index_code)
  api_url <- "/uapi/domestic-stock/v1/quotations/inquire-index-price"
  tr_id <- "FHPUP02100000"
  params <- list(
    "FID_COND_MRKT_DIV_CODE" = "U",
    "FID_INPUT_ISCD" = index_code
  )
  resp <- url_fetch(api_url = api_url, tr_id = tr_id, params = params)
  res <- resp |> resp_body_json()

  if (resp$status_code == 200) {
    if (res$rt_cd == "0") {
      return(data.frame(res$output))
    } else if (res$msg_cd == "EGW00123") {
      set_auth()
      get_current_index(index_code)
    } else {
      raise_error(res)
    }
  } else {
    return(resp$status_code)
  }
}
