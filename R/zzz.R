
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Please get your KIS app key and secret from the website ",
    cli::style_hyperlink(
      text = "https://apiportal.koreainvestment.com/",
      url = "https://apiportal.koreainvestment.com/"
    )
  )
}
