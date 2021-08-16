# Modified from the {boxr} package
# https://github.com/r-box/boxr/blob/28ccd2610922b53e0275d4d128f29781b92970e0/R/boxr_auth.R#L580
auth_message <- function(pw_info) {

    cli::cli_div(theme = list(ul = list(`list-style-type` = crayon::red(cli::symbol$bullet),
                                        `margin-left` = -2)))
    cli::cli_ul("You may wish to add to your {.file .Renviron} file:")
    cli::cli_text(crayon::silver(pw_info))
    if (clipr::clipr_available()) {
      clipr::write_clip(pw_info)
      cli::cli_text("[Copied to clipboard]")
    }
    cli::cli_ul("To edit your {.file .Renviron} file:")
    cli::cli_text("  - Check that {.pkg usethis} is installed.}")
    cli::cli_text("  - Call {.code usethis::edit_r_environ()}.")
    cli::cli_text("  - Check that {.file .Renviron} ends with a new line.")
    cli::cli_end()

}

#' Create environment password
#'
#' Following the conventions of gargle's `secret_*()` family of functions, this
#' function will generate a random password that can be added to your R
#' enviornment. This will allow you to pass the system variable to external
#' services such as GitHub Actions, which can be useful for encrypting and
#' decrypting authentication tokens.
#'
#' @param service Identifier of the service whose token will be encrypted.
#'
#' @return NA; used for side effects to create environmental variable.
#' @export
#'
#' @examples
#'
#' if (interactive()) {
#' create_env_pw("testing-tokencodr")
#' }
#'
#'
create_env_pw <- function(service) {
  pw <- paste0(get_service_name(service), "=", gen_password())
  auth_message(pw_info = pw)
}

#' Encrypt a token file
#'
#' Following
#' \url{https://gargle.r-lib.org/articles/articles/managing-tokens-securely.html#encrypt-the-secret-file},
#' this function writes an encrypted version of the input file to a specified
#' directory, such as a Shiny Web App's "www" subfolder. The supplied
#' destination path is suffixed with a ".secret" folder.
#'
#' @inheritParams create_env_pw
#' @param input The token file to encrypt, typically a ".json" file.
#' @param destination The output directory you would like to store this file,
#'   e.g. in a Shiny Web App's "www" subdirectory.
#'
#' @return NA; used for side effects to create an encrypted token file.
#' @export
#'
encrypt_token <- function(service, input, destination) {

  if (is.character(input)) {
    input <- readBin(input, "raw", file.size(input))
  }
  else if (!is.raw(input)) {
    cl_abort_class(input, c("character", "raw"))
  }
  destdir <- fs::path(destination, ".secret")
  fs::dir_create(destdir)
  destpath <- fs::path(destdir, service)
  enc <- sodium::data_encrypt(msg = input, key = get_service_password(service),
                              nonce = nonce_code())
  attr(enc, "nonce") <- NULL
  writeBin(enc, destpath)
  invisible(destpath)

}

#' Decrypt an encrypted token file
#'
#' @inheritParams create_env_pw
#' @param path The location of the encrypted token file.
#' @param complete Logical: FALSE by default and will return decrypted raw
#'   bytes. TRUE and will decrypt to character string via [base::rawToChar()].
#'
#' @return Either the raw bytes of the decrypted file or a character string to
#'   pass into authentication functions such as [boxr::box_auth()].
#' @export
#'
decrypt_token <- function(service, path, complete = FALSE) {

  if (!can_decrypt(service)) {
    cli::cli_abort(message = "Decryption not available.")
  }
  raw <- readBin(path, "raw", file.size(path))
  output <- sodium::data_decrypt(bin = raw, key = get_service_password(service),
                                 nonce = nonce_code())

  if (complete) {
    output <- rawToChar(output)
  }

  return(output)

}
