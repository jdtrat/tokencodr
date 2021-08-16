get_service_name <- function(.service) {
  paste0(toupper(.service), "_PASSWORD")
}

service_pw_exists <- function(.service) {
  service <- get_service_name(.service = .service)
  pw <- Sys.getenv(service)
  !identical(pw, "")
}

get_service_password <- function(.service) {
  service <- get_service_name(.service = .service)
  pw <- Sys.getenv(service)

  if (identical(pw, "")) {
    cli::cli_abort("Environmental variable {.envvar {service}} is not defined.")
  }

  sodium::sha256(charToRaw(pw))

}

nonce_code <- function() {
  sodium::hex2bin("92343c62449d83e7292fb5c39244ec6e75da6fa25665f0f5")
}

can_decrypt <- function(.service) {
  check_installed("sodium") && service_pw_exists(.service = .service)
}

gen_password <- function() {
  smpl <- sample(x = c(letters, LETTERS, 0:9),
                 size = 50,
                 replace = TRUE)
  paste0(smpl, collapse = "")
}
