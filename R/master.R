#' Download kospi master file
#'
#' Download kospi_code.mst file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return no return.
#'
#' @examples
#' # download kospi_code.mst
#' \dontrun{download_kospi_master()}
#'
#' @export
download_kospi_master <- function(base_dir) {
  cwd <- getwd()
  url <- "https://new.real.download.dws.co.kr/common/master/kospi_code.mst.zip"
  if (!missing(base_dir)) {
    if (!dir.exists(base_dir))
      dir.create(base_dir)
    setwd(sprintf("%s/%s", cwd, base_dir))
    message("change directory to ", base_dir)
  }
  download.file(url, destfile = "kospi_code.mst.zip")
  unzip("kospi_code.mst.zip")
  file.remove("kospi_code.mst.zip")
  setwd(cwd)
}

#' Get kospi master data frame
#'
#' Get data from kospi_code.mst file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return kospi master data frame
#'
#' @examples
#' # get kospi master data frame
#' \dontrun{kospi_master_download()
#' get_kospi_master_dataframe()
#' }
#'
#' @export
get_kospi_master_dataframe <- function(base_dir) {
  cwd <- getwd()
  file_name <- "kospi_code.mst"
  tmp_file1 <- "kospi_code_part1.tmp"
  tmp_file2 <- "kospi_code_part2.tmp"
  if (!missing(base_dir)) {
    file_name <- sprintf("%s/%s", base_dir, "kospi_code.mst")
    tmp_file1 <- sprintf("%s/%s", base_dir, "kospi_code_part1.tmp")
    tmp_file2 <- sprintf("%s/%s", base_dir, "kospi_code_part2.tmp")
  }
  file.create(tmp_file1)
  file.create(tmp_file2)
  wf1 <- file(tmp_file1, open = "w")
  wf2 <- file(tmp_file2, open = "w")

  con <- file(file_name, "r", encoding = "euc-kr")
  while (TRUE) {
    row <- readLines(con, n = 1)
    nc <- nchar(row)
    rf1 <- substr(row, 0, (nc-228L))
    rf1_1 <- trimws(substr(rf1, 0,  9), which = "right")
    rf1_2 <- trimws(substr(rf1, 10, 21), which = "right")
    rf1_3 <- trimws(substr(rf1, 22, nc-228L), which = "both")
    writeLines(sprintf("%s,%s,%s", rf1_1, rf1_2, rf1_3), con = wf1)
    rf2 <- substr(row, nc-228+2, nc)
    writeLines(rf2, con = wf2)
    if (length(row) == 0)
      break
  }
  close(con)
  close(wf1)
  close(wf2)

  part1_columns <- c("stock_code", "isin", "stock_name")
  df1 <- read.csv(tmp_file1, header = FALSE)
  names(df1) <- part1_columns

  field_specs <- c(
     2,  1,  4,  4, 4,
     1,  1,  1,  1, 1,
     1,  1,  1,  1, 1,
     1,  1,  1,  1, 1,
     1,  1,  1,  1, 1,
     1,  1,  1,  1, 1,
     1,  9,  5,  5, 1,
     1,  1,  2,  1, 1,
     1,  2,  2,  2, 3,
     1,  3, 12, 12, 8,
    15, 21,  2,  7, 1,
     1,  1,  1,  1, 9,
     9,  9,  5,  9, 8,
     9,  3,  1,  1, 1
  )

  part2_columns <- c(
    "group_code"
  , "market_cap_size"
  , "sector_class_large"
  , "sector_class_medium"
  , "sector_class_small"
  , "sector_manufacturing"
  , "low_liquidity"
  , "corporate_governance_index"
  , "kospi200_sector"
  , "kospi100"
  , "kospi50"
  , "krx"
  , "etp"
  , "issuance_of_elw"
  , "krx100"
  , "krx_motor"
  , "krx_semiconductor"
  , "krx_bio"
  , "krx_bank"
  , "spac"
  , "krx_energy_chemical"
  , "krx_steel"
  , "short_term_overheating"
  , "krx_media_communications"
  , "krx_construction"
  , "non1"
  , "krx_securities"
  , "krx_ship"
  , "krx_insurance"
  , "krx_transportation"
  , "sri"
  , "price"
  , "trading_quantity_unit"
  , "extended_trading_quantity_unit"
  , "trading_halt"
  , "delisting_trading"
  , "supervision"
  , "market_warning"
  , "warning_notice"
  , "unfaithful_disclosure"
  , "back_door_listing"
  , "ex_dividend"
  , "face_value_change"
  , "capital_increase"
  , "deposit_ratio"
  , "credit_available"
  , "credit_period"
  , "previous_trading_volume"
  , "face_value"
  , "listing_date"
  , "listed_stock"
  , "capital"
  , "settlement_month"
  , "public_offering_price"
  , "preferred_stocks"
  , "overheated_short_selling"
  , "abnormal_soaring"
  , "krx300"
  , "kospi"
  , "sales"
  , "operating_profit"
  , "ordinary_profit"
  , "net_income"
  , "roe"
  , "base_year_month"
  , "market_cap"
  , "group_company_code"
  , "exceeding_credit_limit"
  , "secured_loan_available"
  , "stock_loan_available"
  )

  df2 <- read.fwf(tmp_file2, widths = field_specs, header = FALSE,
                  col.names = part2_columns)

  if (nrow(df1) == nrow(df2))
    df <- cbind(df1, df2)

  file.remove(tmp_file1)
  file.remove(tmp_file2)

  return(df)
}

#' Download kosdaq master file
#'
#' Download kosdaq_code.mst file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return no return.
#'
#' @examples
#' # download kosdaq_code.mst
#' \dontrun{download_kosdaq_master()}
#'
#' @export
download_kosdaq_master <- function(base_dir) {
  cwd <- getwd()
  url <- "https://new.real.download.dws.co.kr/common/master/kosdaq_code.mst.zip"
  if (!missing(base_dir)) {
    if (!dir.exists(base_dir))
      dir.create(base_dir)
    setwd(sprintf("%s/%s", cwd, base_dir))
    message("change directory to ", base_dir)
  }
  download.file(url, destfile = "kosdaq_code.mst.zip")
  unzip("kosdaq_code.mst.zip")
  file.remove("kosdaq_code.mst.zip")
  setwd(cwd)
}

#' Get kosdaq master data frame
#'
#' Get data from kosdaq_code.mst file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return kosdaq master data frame
#'
#' @examples
#' # get kosdaq master data frame
#' \dontrun{kosdaq_master_download()
#' get_kosdaq_master_dataframe()
#' }
#'
#' @export
get_kosdaq_master_dataframe <- function(base_dir) {
  cwd <- getwd()
  file_name <- "kosdaq_code.mst"
  tmp_file1 <- "kosdaq_code_part1.tmp"
  tmp_file2 <- "kosdaq_code_part2.tmp"
  if (!missing(base_dir)) {
    file_name <- sprintf("%s/%s", base_dir, "kosdaq_code.mst")
    tmp_file1 <- sprintf("%s/%s", base_dir, "kosdaq_code_part1.tmp")
    tmp_file2 <- sprintf("%s/%s", base_dir, "kosdaq_code_part2.tmp")
  }
  file.create(tmp_file1)
  file.create(tmp_file2)
  wf1 <- file(tmp_file1, open = "w")
  wf2 <- file(tmp_file2, open = "w")

  con <- file(file_name, "r", encoding = "euc-kr")
  while (TRUE) {
    row <- readLines(con, n = 1)
    nc <- nchar(row)
    rf1 <- substr(row, 0, (nc-222L))
    rf1_1 <- trimws(substr(rf1, 0,  9), which = "right")
    rf1_2 <- trimws(substr(rf1, 10, 21), which = "right")
    rf1_3 <- trimws(substr(rf1, 22, nc-222L), which = "both")
    writeLines(sprintf("%s,%s,%s", rf1_1, rf1_2, rf1_3), con = wf1)
    rf2 <- substr(row, nc-222+2, nc)
    writeLines(rf2, con = wf2)
    if (length(row) == 0)
      break
  }
  close(con)
  close(wf1)
  close(wf2)

  part1_columns <- c("stock_code", "isin", "stock_name")
  df1 <- read.csv(tmp_file1, header = FALSE)
  names(df1) <- part1_columns

  field_specs <- c(
     2,  1,
     4,  4,  4,  1,  1,
     1,  1,  1,  1,  1,
     1,  1,  1,  1,  1,
     1,  1,  1,  1,  1,
     1,  1,  1,  1,  9,
     5,  5,  1,  1,  1,
     2,  1,  1,  1,  2,
     2,  2,  3,  1,  3,
    12, 12,  8, 15, 21,
     2,  7,  1,  1,  1,
     1,  9,  9,  9,  5,
     9,  8,  9,  3,  1,
     1,  1
  )

  part2_columns <- c(
    "group_code"
  , "market_cap_size"
  , "sector_class_large"
  , "sector_class_medium"
  , "sector_class_small"
  , "start_up"
  , "low_liquidity"
  , "krx"
  , "etp"
  , "krx100"
  , "krx_motor"
  , "krx_semiconductor"
  , "krx_bio"
  , "krx_bank"
  , "spac"
  , "krx_energy_chemical"
  , "krx_steel"
  , "short_term_overheating"
  , "krx_media_communications"
  , "krx_construction"
  , "kosdaq_caution"
  , "krx_securities"
  , "krx_ship"
  , "krx_insurance"
  , "krx_transportation"
  , "kosdaq150"
  , "price"
  , "trading_quantity_unit"
  , "extended_trading_quantity_unit"
  , "trading_halt"
  , "delisting_trading"
  , "supervision"
  , "market_warning"
  , "warning_notice"
  , "unfaithful_disclosure"
  , "back_door_listing"
  , "ex_dividend"
  , "face_value_change"
  , "capital_increase"
  , "deposit_ratio"
  , "credit_available"
  , "credit_period"
  , "previous_trading_volume"
  , "face_value"
  , "listing_date"
  , "listed_stock"
  , "capital"
  , "settlement_month"
  , "public_offering_price"
  , "preferred_stocks"
  , "overheated_short_selling"
  , "abnormal_soaring"
  , "krx300"
  , "sales"
  , "operating_profit"
  , "ordinary_profit"
  , "net_income"
  , "roe"
  , "base_year_month"
  , "market_cap"
  , "group_company_code"
  , "exceeding_credit_limit"
  , "secured_loan_available"
  , "stock_loan_available"
  )

  df2 <- read.fwf(tmp_file2, widths = field_specs, header = FALSE,
                  col.names = part2_columns)

  if (nrow(df1) == nrow(df2))
    df <- cbind(df1, df2)

  file.remove(tmp_file1)
  file.remove(tmp_file2)

  return(df)
}
