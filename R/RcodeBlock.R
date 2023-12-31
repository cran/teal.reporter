#' @title `RcodeBlock`
#' @keywords internal
RcodeBlock <- R6::R6Class( # nolint: object_name_linter.
  classname = "RcodeBlock",
  inherit = ContentBlock,
  public = list(
    #' @description Returns a `RcodeBlock` object.
    #'
    #' @details Returns a `RcodeBlock` object with no content and no parameters.
    #'
    #' @param content (`character(1)` or `character(0)`) a string assigned to this `RcodeBlock`
    #' @param ... any `rmarkdown` R chunk parameter and it value.
    #'
    #' @return `RcodeBlock`
    initialize = function(content = character(0), ...) {
      super$set_content(content)
      self$set_params(list(...))
      invisible(self)
    },
    #' @description Sets the parameters of this `RcodeBlock`.
    #'
    #' @details The parameters has bearing on the rendering of this block.
    #'
    #' @param params (`list`) any `rmarkdown` R chunk parameter and its value.
    #'
    #' @return invisibly self
    set_params = function(params) {
      checkmate::assert_list(params, names = "named")
      checkmate::assert_subset(names(params), self$get_available_params())
      private$params <- params
      invisible(self)
    },
    #' @description Returns the parameters of this `RcodeBlock`.
    #'
    #' @return `character` the parameters of this `RcodeBlock`
    get_params = function() {
      private$params
    },
    #' @description Returns an array of parameters available to this `RcodeBlock`.
    #'
    #' @return a `character` array of parameters
    get_available_params = function() {
      names(knitr::opts_chunk$get())
    },
    #' @description Create the `RcodeBlock` from a list.
    #'
    #' @param x `named list` with two fields `c("text", "params")`.
    #' Use the `get_available_params` method to get all possible parameters.
    #'
    #' @return invisibly self
    from_list = function(x) {
      checkmate::assert_list(x)
      checkmate::assert_names(names(x), must.include = c("text", "params"))
      self$set_content(x$text)
      self$set_params(x$params)
      invisible(self)
    },
    #' @description Convert the `RcodeBlock` to a list.
    #'
    #' @return `named list` with a text and `params`.
    to_list = function() {
      list(text = self$get_content(), params = self$get_params())
    }
  ),
  private = list(
    params = list()
  ),
  lock_objects = TRUE,
  lock_class = TRUE
)
