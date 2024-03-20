#' @title Download KOSPI (KOSDAQ) master file
#'
#' @description
#' Download kospi_code.mst (kosdaq_code.mst) file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return no return value
#'
#' @examples
#' # download kospi_code.mst
#' \dontrun{
#' download_kospi_master()}
#'
#' # download kosdaq_code.mst
#' \dontrun{
#' download_kosdaq_master()}
#'
#' @export
download_kospi_master <- function(base_dir) {
  cwd <- getwd()
  url <- "https://new.real.download.dws.co.kr/common/master/kospi_code.mst.zip"
  if (!missing(base_dir)) {
    if (!dir.exists(base_dir))
      dir.create(base_dir)
    setwd(base_dir)
    message("change directory to ", base_dir)
  }
  download.file(url, destfile = "kospi_code.mst.zip")
  unzip("kospi_code.mst.zip")
  file.remove("kospi_code.mst.zip")
  setwd(cwd)
}

#' @rdname download_kospi_master
#' @export
download_kosdaq_master <- function(base_dir) {
  cwd <- getwd()
  url <- "https://new.real.download.dws.co.kr/common/master/kosdaq_code.mst.zip"
  if (!missing(base_dir)) {
    if (!dir.exists(base_dir))
      dir.create(base_dir)
    setwd(base_dir)
    message("change directory to ", base_dir)
  }
  download.file(url, destfile = "kosdaq_code.mst.zip")
  unzip("kosdaq_code.mst.zip")
  file.remove("kosdaq_code.mst.zip")
  setwd(cwd)
}

#' @title get KOSPI (KOSDAQ) master data frame
#'
#' @description
#' Get data from kospi_code.mst (kosdaq_code.mst) file.
#'
#' @param base_dir destination folder, if missing, current working directory.
#'
#' @return KOSPI (KOSDAQ) master dataframe
#'
#' @examples
#' # get kospi master dataframe
#' \dontrun{
#' download_kospi_master()
#' get_kospi_master_dataframe()}
#'
#' # get kosdaq master dataframe
#' \dontrun{
#' download_kosdaq_master()
#' get_kosdaq_master_dataframe()}
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

  labels <- c(
    "\\ub2e8\\ucd95\\ucf54\\ub4dc"
  , "\\ud45c\\uc900\\ucf54\\ub4dc"
  , "\\ud55c\\uae00\\uc885\\ubaa9\\uba85"
  , "\uadf8\ub8f9\ucf54\ub4dc"
  , "\uc2dc\uac00\ucd1d\uc561\uaddc\ubaa8"
  , "\uc9c0\uc218\uc5c5\uc885\ub300\ubd84\ub958"
  , "\uc9c0\uc218\uc5c5\uc885\uc911\ubd84\ub958"
  , "\uc9c0\uc218\uc5c5\uc885\uc18c\ubd84\ub958"
  , "\uc81c\uc870\uc5c5"
  , "\uc800\uc720\ub3d9\uc131"
  , "\uc9c0\ubc30\uad6c\uc870\uc9c0\uc218\uc885\ubaa9"
  , "KOSPI200\uc139\ud130\uc5c5\uc885"
  , "KOSPI100"
  , "KOSPI50"
  , "KRX"
  , "ETP"
  , "ELW\ubc1c\ud589"
  , "KRX100"
  , "KRX\uc790\ub3d9\ucc28"
  , "KRX\ubc18\ub3c4\uccb4"
  , "KRX\ubc14\uc774\uc624"
  , "KRX\uc740\ud589"
  , "SPAC"
  , "KRX\uc5d0\ub108\uc9c0\ud654\ud559"
  , "KRX\ucca0\uac15"
  , "\ub2e8\uae30\uacfc\uc5f4"
  , "KRX\ubbf8\ub514\uc5b4\ud1b5\uc2e0"
  , "KRX\uac74\uc124"
  , "Non1"
  , "KRX\uc99d\uad8c"
  , "KRX\uc120\ubc15"
  , "KRX\uc139\ud130_\ubcf4\ud5d8"
  , "KRX\uc139\ud130_\uc6b4\uc1a1"
  , "SRI"
  , "\uae30\uc900\uac00"
  , "\ub9e4\ub9e4\uc218\ub7c9\ub2e8\uc704"
  , "\uc2dc\uac04\uc678\uc218\ub7c9\ub2e8\uc704"
  , "\uac70\ub798\uc815\uc9c0"
  , "\uc815\ub9ac\ub9e4\ub9e4"
  , "\uad00\ub9ac\uc885\ubaa9"
  , "\uc2dc\uc7a5\uacbd\uace0"
  , "\uacbd\uace0\uc608\uace0"
  , "\ubd88\uc131\uc2e4\uacf5\uc2dc"
  , "\uc6b0\ud68c\uc0c1\uc7a5"
  , "\ub77d\uad6c\ubd84"
  , "\uc561\uba74\ubcc0\uacbd"
  , "\uc99d\uc790\uad6c\ubd84"
  , "\uc99d\uac70\uae08\ube44\uc728"
  , "\uc2e0\uc6a9\uac00\ub2a5"
  , "\uc2e0\uc6a9\uae30\uac04"
  , "\uc804\uc77c\uac70\ub798\ub7c9"
  , "\uc561\uba74\uac00"
  , "\uc0c1\uc7a5\uc77c\uc790"
  , "\uc0c1\uc7a5\uc8fc\uc218"
  , "\uc790\ubcf8\uae08"
  , "\uacb0\uc0b0\uc6d4"
  , "\uacf5\ubaa8\uac00"
  , "\uc6b0\uc120\uc8fc"
  , "\uacf5\ub9e4\ub3c4\uacfc\uc5f4"
  , "\uc774\uc0c1\uae09\ub4f1"
  , "KRX300"
  , "KOSPI"
  , "\ub9e4\ucd9c\uc561"
  , "\uc601\uc5c5\uc774\uc775"
  , "\uacbd\uc0c1\uc774\uc775"
  , "\ub2f9\uae30\uc21c\uc774\uc775"
  , "ROE"
  , "\uae30\uc900\ub144\uc6d4"
  , "\uc2dc\uac00\ucd1d\uc561"
  , "\uadf8\ub8f9\uc0ac\ucf54\ub4dc"
  , "\ud68c\uc0ac\uc2e0\uc6a9\ud55c\ub3c4\ucd08\uacfc"
  , "\ub2f4\ubcf4\ub300\ucd9c\uac00\ub2a5"
  , "\ub300\uc8fc\uac00\ub2a5"
  )
  labels <- stringi::stri_unescape_unicode(labels)
  set_label(df, labels)

  file.remove(tmp_file1)
  file.remove(tmp_file2)

  return(df)
}

#' @rdname get_kospi_master_dataframe
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

  labels <- c(
    "\ub2e8\ucd95\ucf54\ub4dc"
  , "\ud45c\uc900\ucf54\ub4dc"
  , "\ud55c\uae00\uc885\ubaa9\uba85"
  , "\uc99d\uad8c\uadf8\ub8f9\uad6c\ubd84\ucf54\ub4dc"
  , "\uc2dc\uac00\ucd1d\uc561 \uaddc\ubaa8 \uad6c\ubd84 \ucf54\ub4dc \uc720\uac00"
  , "\uc9c0\uc218\uc5c5\uc885 \ub300\ubd84\ub958 \ucf54\ub4dc"
  , "\uc9c0\uc218 \uc5c5\uc885 \uc911\ubd84\ub958 \ucf54\ub4dc"
  , "\uc9c0\uc218\uc5c5\uc885 \uc18c\ubd84\ub958 \ucf54\ub4dc"
  , "\ubca4\ucc98\uae30\uc5c5 \uc5ec\ubd80 (Y/N)"
  , "\uc800\uc720\ub3d9\uc131\uc885\ubaa9 \uc5ec\ubd80"
  , "KRX \uc885\ubaa9 \uc5ec\ubd80"
  , "ETP \uc0c1\ud488\uad6c\ubd84\ucf54\ub4dc"
  , "KRX100 \uc885\ubaa9 \uc5ec\ubd80 (Y/N)"
  , "KRX \uc790\ub3d9\ucc28 \uc5ec\ubd80"
  , "KRX \ubc18\ub3c4\uccb4 \uc5ec\ubd80"
  , "KRX \ubc14\uc774\uc624 \uc5ec\ubd80"
  , "KRX \uc740\ud589 \uc5ec\ubd80"
  , "\uae30\uc5c5\uc778\uc218\ubaa9\uc801\ud68c\uc0ac\uc5ec\ubd80"
  , "KRX \uc5d0\ub108\uc9c0 \ud654\ud559 \uc5ec\ubd80"
  , "KRX \ucca0\uac15 \uc5ec\ubd80"
  , "\ub2e8\uae30\uacfc\uc5f4\uc885\ubaa9\uad6c\ubd84\ucf54\ub4dc"
  , "KRX \ubbf8\ub514\uc5b4 \ud1b5\uc2e0 \uc5ec\ubd80"
  , "KRX \uac74\uc124 \uc5ec\ubd80"
  , "(\ucf54\uc2a4\ub2e5)\ud22c\uc790\uc8fc\uc758\ud658\uae30\uc885\ubaa9\uc5ec\ubd80"
  , "KRX \uc99d\uad8c \uad6c\ubd84"
  , "KRX \uc120\ubc15 \uad6c\ubd84"
  , "KRX\uc139\ud130\uc9c0\uc218 \ubcf4\ud5d8\uc5ec\ubd80"
  , "KRX\uc139\ud130\uc9c0\uc218 \uc6b4\uc1a1\uc5ec\ubd80"
  , "KOSDAQ150\uc9c0\uc218\uc5ec\ubd80 (Y, N)"
  , "\uc8fc\uc2dd \uae30\uc900\uac00"
  , "\uc815\uaddc \uc2dc\uc7a5 \ub9e4\ub9e4 \uc218\ub7c9 \ub2e8\uc704"
  , "\uc2dc\uac04\uc678 \uc2dc\uc7a5 \ub9e4\ub9e4 \uc218\ub7c9 \ub2e8\uc704"
  , "\uac70\ub798\uc815\uc9c0 \uc5ec\ubd80"
  , "\uc815\ub9ac\ub9e4\ub9e4 \uc5ec\ubd80"
  , "\uad00\ub9ac \uc885\ubaa9 \uc5ec\ubd80"
  , "\uc2dc\uc7a5 \uacbd\uace0 \uad6c\ubd84 \ucf54\ub4dc"
  , "\uc2dc\uc7a5 \uacbd\uace0\uc704\ud5d8 \uc608\uace0 \uc5ec\ubd80"
  , "\ubd88\uc131\uc2e4 \uacf5\uc2dc \uc5ec\ubd80"
  , "\uc6b0\ud68c \uc0c1\uc7a5 \uc5ec\ubd80"
  , "\ub77d\uad6c\ubd84 \ucf54\ub4dc"
  , "\uc561\uba74\uac00 \ubcc0\uacbd \uad6c\ubd84 \ucf54\ub4dc"
  , "\uc99d\uc790 \uad6c\ubd84 \ucf54\ub4dc"
  , "\uc99d\uac70\uae08 \ube44\uc728"
  , "\uc2e0\uc6a9\uc8fc\ubb38 \uac00\ub2a5 \uc5ec\ubd80"
  , "\uc2e0\uc6a9\uae30\uac04"
  , "\uc804\uc77c \uac70\ub798\ub7c9"
  , "\uc8fc\uc2dd \uc561\uba74\uac00"
  , "\uc8fc\uc2dd \uc0c1\uc7a5 \uc77c\uc790"
  , "\uc0c1\uc7a5 \uc8fc\uc218(\ucc9c)"
  , "\uc790\ubcf8\uae08"
  , "\uacb0\uc0b0 \uc6d4"
  , "\uacf5\ubaa8 \uac00\uaca9"
  , "\uc6b0\uc120\uc8fc \uad6c\ubd84 \ucf54\ub4dc"
  , "\uacf5\ub9e4\ub3c4\uacfc\uc5f4\uc885\ubaa9\uc5ec\ubd80"
  , "\uc774\uc0c1\uae09\ub4f1\uc885\ubaa9\uc5ec\ubd80"
  , "KRX300 \uc885\ubaa9 \uc5ec\ubd80 (Y/N)"
  , "\ub9e4\ucd9c\uc561"
  , "\uc601\uc5c5\uc774\uc775"
  , "\uacbd\uc0c1\uc774\uc775"
  , "\ub2e8\uae30\uc21c\uc774\uc775"
  , "ROE(\uc790\uae30\uc790\ubcf8\uc774\uc775\ub960)"
  , "\uae30\uc900\ub144\uc6d4"
  , "\uc804\uc77c\uae30\uc900 \uc2dc\uac00\ucd1d\uc561 (\uc5b5)"
  , "\uadf8\ub8f9\uc0ac \ucf54\ub4dc"
  , "\ud68c\uc0ac\uc2e0\uc6a9\ud55c\ub3c4\ucd08\uacfc\uc5ec\ubd80"
  , "\ub2f4\ubcf4\ub300\ucd9c\uac00\ub2a5\uc5ec\ubd80"
  , "\ub300\uc8fc\uac00\ub2a5\uc5ec\ubd80"
  )
  labels <- stringi::stri_unescape_unicode(labels)
  set_label(df, labels)

  file.remove(tmp_file1)
  file.remove(tmp_file2)

  return(df)
}

#' @title Get KOSPI (KOSDAQ) master
#'
#' @description
#' Download KOSPI (KOSDAQ) master file in temp directory and get the data from the file
#'
#' @return a data.frame
#'
#' @examples
#' # get kospi master
#' \dontrun{
#' kospi <- get_kospi_master()
#' View(kospi)}
#'
#' # get kosdaq master
#' \dontrun{
#' kosdaq <- get_kosdaq_master()
#' View(kosdaq)}
#'
#' @export
get_kospi_master <- function() {
  base_dir <- tempdir()
  download_kospi_master(base_dir)
  get_kospi_master_dataframe(base_dir)
}

#' @rdname get_kospi_master
#' @export
get_kosdaq_master <- function() {
  base_dir <- tempdir()
  download_kosdaq_master(base_dir)
  get_kosdaq_master_dataframe(base_dir)
}
