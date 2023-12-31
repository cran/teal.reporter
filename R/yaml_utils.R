#' @title quoted string for `yaml`
#' @description add quoted attribute for `yaml` package
#' @param x `character`
#' @keywords internal
yaml_quoted <- function(x) {
  attr(x, "quoted") <- TRUE
  x
}

#' @title wrap a `yaml` string to the `markdown` header
#' @description wrap a `yaml` string to the `markdown` header.
#' @param x `character` `yaml` formatted string.
#' @keywords internal
md_header <- function(x) {
  paste0("---\n", x, "---\n")
}

#' @title Convert a character of a `yaml` boolean to a logical value
#' @description convert a character of a `yaml` boolean to a logical value.
#' @param input `character`
#' @param name `charcter`
#' @param pos_logi `character` vector of `yaml` values which should be treated as `TRUE`.
#' @param neg_logi `character` vector of `yaml` values which should be treated as `FALSE`.
#' @param silent `logical` if to suppress the messages and warnings.
#' @return `input` argument or the appropriate `logical` value.
#' @keywords internal
conv_str_logi <- function(input,
                          name = "",
                          pos_logi = c("TRUE", "true", "True", "yes", "y", "Y", "on"),
                          neg_logi = c("FALSE", "false", "False", "no", "n", "N", "off"),
                          silent = TRUE) {
  checkmate::assert_string(input)
  checkmate::assert_string(name)
  checkmate::assert_character(pos_logi)
  checkmate::assert_character(neg_logi)
  checkmate::assert_flag(silent)

  all_logi <- c(pos_logi, neg_logi)
  if (input %in% all_logi) {
    if (isFALSE(silent)) {
      message(sprintf("The '%s' value should be a logical, so it is automatically converted.", input))
    }
    input %in% pos_logi
  } else {
    input
  }
}

#' @title Get document output types from the `rmarkdown` package
#'
#' @description `r lifecycle::badge("experimental")`
#' get document output types from the `rmarkdown` package.
#' @return `character` vector.
#' @export
#' @examples
#' rmd_outputs()
rmd_outputs <- function() {
  rmarkdown_namespace <- asNamespace("rmarkdown")
  ls(rmarkdown_namespace)[grep("_document|_presentation", ls(rmarkdown_namespace))]
}

#' @title Get document output arguments from the `rmarkdown` package
#'
#' @description `r lifecycle::badge("experimental")`
#' get document output arguments from the `rmarkdown` package
#' @param output_name `character` `rmarkdown` output name.
#' @param default_values `logical` if to return a default values for each argument.
#' @export
#' @examples
#' rmd_output_arguments("pdf_document")
#' rmd_output_arguments("pdf_document", TRUE)
rmd_output_arguments <- function(output_name, default_values = FALSE) {
  checkmate::assert_string(output_name)
  checkmate::assert_subset(output_name, rmd_outputs())

  rmarkdown_namespace <- asNamespace("rmarkdown")
  if (default_values) {
    formals(rmarkdown_namespace[[output_name]])
  } else {
    names(formals(rmarkdown_namespace[[output_name]]))
  }
}

#' @title Parse a Named List to the `Rmd` `yaml` Header
#' @description `r lifecycle::badge("experimental")`
#' parse a named list to the `Rmd` `yaml` header, so the developer gets automatically tabulated `Rmd` `yaml` header.
#' Only a non nested (flat) list will be processed,
#' where as a nested list is directly processed with the [`yaml::as.yaml`] function.
#' All `Rmd` `yaml` header fields from the vector are supported,
#' `c("author", "date", "title", "subtitle", "abstract", "keywords", "subject", "description", "category", "lang")`.
#' Moreover all `output`field types in the `rmarkdown` package and their arguments are supported.
#' @param input_list `named list` non nested with slots names and their values compatible with `Rmd` `yaml` header.
#' @param as_header `logical` optionally wrap with result with the internal `md_header()`, default `TRUE`.
#' @param convert_logi `logical` convert a character values to logical,
#'  if they are recognized as quoted `yaml` logical values , default `TRUE`.
#' @param multi_output `logical` multi `output` slots in the `input` argument, default `FALSE`.
#' @param silent `logical` suppress messages and warnings, default `FALSE`.
#' @return `character` with `rmd_yaml_header` class,
#' result of [`yaml::as.yaml`], optionally wrapped with internal `md_header()`.
#' @export
#' @examples
#' # nested so using yaml::as.yaml directly
#' as_yaml_auto(
#'   list(author = "", output = list(pdf_document = list(toc = TRUE)))
#' )
#'
#' # auto parsing for a flat list, like shiny input
#' input <- list(author = "", output = "pdf_document", toc = TRUE, keep_tex = TRUE)
#' as_yaml_auto(input)
#'
#' as_yaml_auto(list(author = "", output = "pdf_document", toc = TRUE, keep_tex = "TRUE"))
#'
#' as_yaml_auto(list(
#'   author = "", output = "pdf_document", toc = TRUE, keep_tex = TRUE,
#'   wrong = 2
#' ))
#'
#' as_yaml_auto(list(author = "", output = "pdf_document", toc = TRUE, keep_tex = 2),
#'   silent = TRUE
#' )
#'
#' input <- list(author = "", output = "pdf_document", toc = TRUE, keep_tex = "True")
#' as_yaml_auto(input)
#' as_yaml_auto(input, convert_logi = TRUE, silent = TRUE)
#' as_yaml_auto(input, silent = TRUE)
#' as_yaml_auto(input, convert_logi = FALSE, silent = TRUE)
#'
#' as_yaml_auto(
#'   list(
#'     author = "", output = "pdf_document",
#'     output = "html_document", toc = TRUE, keep_tex = TRUE
#'   ),
#'   multi_output = TRUE
#' )
#' as_yaml_auto(
#'   list(
#'     author = "", output = "pdf_document",
#'     output = "html_document", toc = "True", keep_tex = TRUE
#'   ),
#'   multi_output = TRUE
#' )
as_yaml_auto <- function(input_list,
                         as_header = TRUE,
                         convert_logi = TRUE,
                         multi_output = FALSE,
                         silent = FALSE) {
  checkmate::assert_logical(as_header)
  checkmate::assert_logical(convert_logi)
  checkmate::assert_logical(silent)
  checkmate::assert_logical(multi_output)

  if (multi_output) {
    checkmate::assert_list(input_list, names = "named")
  } else {
    checkmate::assert_list(input_list, names = "unique")
  }

  is_nested <- function(x) any(unlist(lapply(x, is.list)))
  if (is_nested(input_list)) {
    result <- input_list
  } else {
    result <- list()
    input_nams <- names(input_list)

    # top fields
    top_fields <- c(
      "author", "date", "title", "subtitle", "abstract",
      "keywords", "subject", "description", "category", "lang"
    )
    for (itop in top_fields) {
      if (itop %in% input_nams) {
        result[[itop]] <- switch(itop,
          date = as.character(input_list[[itop]]),
          input_list[[itop]]
        )
      }
    }

    # output field
    doc_types <- unlist(input_list[input_nams == "output"])
    if (length(doc_types)) {
      for (dtype in doc_types) {
        doc_type_args <- rmd_output_arguments(dtype, TRUE)
        doc_type_args_nams <- names(doc_type_args)
        any_output_arg <- any(input_nams %in% doc_type_args_nams)

        not_found_args <- setdiff(input_nams, c(doc_type_args_nams, top_fields, "output"))
        if (isFALSE(silent) && length(not_found_args) > 0 && isFALSE(multi_output)) {
          warning(sprintf("Not recognized and skipped arguments: %s", paste(not_found_args, collapse = ", ")))
        }

        if (any_output_arg) {
          doc_list <- list()
          doc_list[[dtype]] <- list()
          for (e in intersect(input_nams, doc_type_args_nams)) {
            if (is.logical(doc_type_args[[e]]) && is.character(input_list[[e]])) {
              pos_logi <- c("TRUE", "true", "True", "yes", "y", "Y", "on")
              neg_logi <- c("FALSE", "false", "False", "no", "n", "N", "off")
              all_logi <- c(pos_logi, neg_logi)
              if (input_list[[e]] %in% all_logi && convert_logi) {
                input_list[[e]] <- conv_str_logi(input_list[[e]], e,
                  pos_logi = pos_logi,
                  neg_logi = neg_logi, silent = silent
                )
              }
            }

            doc_list[[dtype]][[e]] <- input_list[[e]]
          }
          result[["output"]] <- append(result[["output"]], doc_list)
        } else {
          result[["output"]] <- append(result[["output"]], input_list[["output"]])
        }
      }
    }
  }

  result <- yaml::as.yaml(result)
  if (as_header) {
    result <- md_header(result)
  }
  structure(result, class = "rmd_yaml_header")
}

#' @title Print method for the `yaml_header` class
#'
#' @description `r lifecycle::badge("experimental")`
#' Print method for the `yaml_header` class.
#' @param x `rmd_yaml_header` class object.
#' @param ... optional text.
#' @return NULL
#' @exportS3Method
#' @examples
#' input <- list(author = "", output = "pdf_document", toc = TRUE, keep_tex = TRUE)
#' out <- as_yaml_auto(input)
#' out
#' print(out)
print.rmd_yaml_header <- function(x, ...) {
  cat(x, ...)
}
