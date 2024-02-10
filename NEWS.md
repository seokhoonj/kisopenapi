# kisopenapi (development version)

## new features

* `kospi_master_download()` and `get_kospi_master_dataframe()` functions are added. if you execute these two functions sequentially, you can obtain the KOSPI master data frame. and it contains a lot of informations.

* `kosdaq_master_download()` and `get_kosdaq_master_dataframe()` functions are same as above.

* `kospi_master_columns` and `kosdaq_master_columns` datasets contain English and Korean column names.

## bug fixes

* modified typo .Reviron -> .Renviron and added `usethis::edit_r_environ()` for the environment variable checking error messages.


# kisopenapi 0.0.2

## bug fixes

* A return value typo error of `print_trading_env()` function (livr -\> live) is modified.

* `inherits(orders, "data.frame")` condition is added to `kis_cancel_all()` function, because the `get_orders()` function inside of `kis_cancel_all()` function returns a list of error code if the class of return value is not a `data.frame`. So if `get_orders()` function returns a list of error code, the `print_trading_env()` function returns the same list of error code.
