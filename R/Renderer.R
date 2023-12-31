#' @title `Renderer`
#' @keywords internal
Renderer <- R6::R6Class( # nolint: object_name_linter.
  classname = "Renderer",
  public = list(
    #' @description Returns a `Renderer` object.
    #'
    #' @details Returns a `Renderer` object.
    #'
    #' @return `Renderer` object.
    initialize = function() {
      tmp_dir <- tempdir()
      output_dir <- file.path(tmp_dir, sprintf("report_%s", gsub("[.]", "", format(Sys.time(), "%Y%m%d%H%M%OS4"))))
      dir.create(path = output_dir)
      private$output_dir <- output_dir
      invisible(self)
    },
    #' @description Finalizes a `Renderer` object.
    finalize = function() {
      unlink(private$output_dir, recursive = TRUE)
    },
    #' @description getting the `Rmd` text which could be easily rendered later.
    #'
    #' @param blocks `list` of `c("TextBlock", "PictureBlock", "NewpageBlock")` objects.
    #' @param yaml_header `character` a `rmarkdown` `yaml` header.
    #' @param global_knitr `list` a global `knitr` parameters, like echo.
    #' But if local parameter is set it will have priority.
    #' Defaults to empty `list()`.
    #'
    #' @return `character` a `Rmd` text (`yaml` header + body), ready to be rendered.
    renderRmd = function(blocks, yaml_header, global_knitr = list()) {
      checkmate::assert_list(blocks, c("TextBlock", "PictureBlock", "NewpageBlock", "TableBlock", "RcodeBlock"))
      if (missing(yaml_header)) {
        yaml_header <- md_header(yaml::as.yaml(list(title = "Report")))
      }
      parsed_yaml <- yaml_header
      parsed_global_knitr <- sprintf(
        "\n```{r setup, include=FALSE}\nknitr::opts_chunk$set(%s)\n```\n",
        capture.output(dput(global_knitr))
      )
      parsed_blocks <- paste(
        unlist(
          lapply(blocks, function(b) private$block2md(b))
        ),
        collapse = "\n\n"
      )

      rmd_text <- paste0(parsed_yaml, "\n", parsed_global_knitr, "\n", parsed_blocks, "\n")
      tmp <- tempfile(fileext = ".Rmd")
      input_path <- file.path(
        private$output_dir,
        sprintf("input_%s.Rmd", gsub("[.]", "", format(Sys.time(), "%Y%m%d%H%M%OS3")))
      )
      cat(rmd_text, file = input_path)
      input_path
    },
    #' @description Renders the content of this `Report` to the output file
    #'
    #' @param blocks `list` of `c("TextBlock", "PictureBlock", "NewpageBlock")` objects.
    #' @param yaml_header `character` an `rmarkdown` `yaml` header.
    #' @param global_knitr `list` a global `knitr` parameters, like echo.
    #' But if local parameter is set it will have priority.
    #' Defaults to empty `list()`.
    #' @param ... `rmarkdown::render` arguments, `input` and `output_dir` should not be updated.z
    #'
    #' @return `character` path to the output
    render = function(blocks, yaml_header, global_knitr = list(), ...) {
      args <- list(...)
      input_path <- self$renderRmd(blocks, yaml_header, global_knitr)
      args <- append(args, list(
        input = input_path,
        output_dir = private$output_dir,
        output_format = "all",
        quiet = TRUE
      ))
      args_nams <- unique(names(args))
      args <- lapply(args_nams, function(x) args[[x]])
      names(args) <- args_nams
      do.call(rmarkdown::render, args)
    },
    #' @description get `output_dir` field
    #'
    #' @return `character` a `output_dir` field path.
    get_output_dir = function() {
      private$output_dir
    }
  ),
  private = list(
    output_dir = character(0),
    # factory method
    block2md = function(block) {
      if (inherits(block, "TextBlock")) {
        private$textBlock2md(block)
      } else if (inherits(block, "RcodeBlock")) {
        private$rcodeBlock2md(block)
      } else if (inherits(block, "PictureBlock")) {
        private$pictureBlock2md(block)
      } else if (inherits(block, "TableBlock")) {
        private$tableBlock2md(block)
      } else if (inherits(block, "NewpageBlock")) {
        block$get_content()
      } else {
        stop("Unknown block class")
      }
    },
    # card specific methods
    textBlock2md = function(block) {
      text_style <- block$get_style()
      block_content <- block$get_content()
      switch(text_style,
        "default" = block_content,
        "verbatim" = sprintf("\n```\n%s\n```\n", block_content),
        "header2" = paste0("## ", block_content),
        "header3" = paste0("### ", block_content),
        block_content
      )
    },
    rcodeBlock2md = function(block) {
      params <- block$get_params()
      params <- lapply(params, function(l) if (is.character(l)) shQuote(l) else l)
      block_content <- block$get_content()
      sprintf(
        "\n```{r, %s}\n%s\n```\n",
        paste(names(params), params, sep = "=", collapse = ", "),
        block_content
      )
    },
    pictureBlock2md = function(block) {
      basename_pic <- basename(block$get_content())
      file.copy(block$get_content(), file.path(private$output_dir, basename_pic))
      params <- c(
        `out.width` = "'100%'",
        `out.height` = "'100%'"
      )
      title <- block$get_title()
      if (length(title)) params["fig.cap"] <- shQuote(title)
      sprintf(
        "\n```{r, %s}\nknitr::include_graphics(path = '%s')\n```\n",
        paste(names(params), params, sep = "=", collapse = ", "),
        basename_pic
      )
    },
    tableBlock2md = function(block) {
      basename_table <- basename(block$get_content())
      file.copy(block$get_content(), file.path(private$output_dir, basename_table))
      sprintf("```{r echo = FALSE}\nreadRDS('%s')\n```", basename_table)
    }
  ),
  lock_objects = TRUE,
  lock_class = TRUE
)
