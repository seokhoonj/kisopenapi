# kisopenapi (development version)

# kisopenapi 0.0.2

## bug fixes

* A return value typo error of `print_trading_env()` function (livr -\> live) is modified.

* `inherits(orders, "data.frame")` condition is added to `kis_cancel_all()` function, because the `get_orders()` function inside of `kis_cancel_all()` function returns a list of error code if the class of return value is not a `data.frame`. So if `get_orders()` function returns a list of error code, the `print_trading_env()` function returns the same list of error code.
