
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Please get your KIS api key and secret from the website 'https://apiportal.koreainvestment.com/'"
  )
}
