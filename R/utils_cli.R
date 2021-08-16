cl_abort_class <- function(object, expected_class) {
  obj_name <- deparse(substitute(object))
  obj_class <- class(object)

  must_be <- glue::glue_collapse(
    glue::glue("{.cls <<expected_class>>}",
               .open = "<<", .close = ">>"
    ),
    sep = ", ", last = " or "
  )

  msg <- glue::glue("{.arg {obj_name}} must be <<must_be>>, not of class {.cls {obj_class}}.",
                    .open = "<<", .close = ">>")

  cli::cli_abort(msg)

}
