#' @title `PictureBlock`
#' @keywords internal
#' @noRd
PictureBlock <- R6::R6Class( # nolint: object_name_linter.
  classname = "PictureBlock",
  inherit = FileBlock,
  public = list(
    #' @description Returns a new `PictureBlock` object.
    #'
    #' @param plot (`ggplot`, `grid`) a picture in this `PictureBlock`
    #'
    #' @return a `PictureBlock` object
    initialize = function(plot) {
      if (!missing(plot)) {
        self$set_content(plot)
      }
      invisible(self)
    },
    #' @description Sets the content of this `PictureBlock`.
    #'
    #' @details throws if argument is not a `ggplot`, `grob` or `trellis` plot.
    #'
    #' @param content (`ggplot`, `grob`, `trellis`) a picture in this `PictureBlock`
    #'
    #' @return invisibly self
    set_content = function(content) {
      checkmate::assert_multi_class(content, private$supported_plots)
      path <- tempfile(fileext = ".png")
      grDevices::png(filename = path, width = private$dim[1], height = private$dim[2])
      tryCatch(
        expr = {
          if (inherits(content, "grob")) {
            grid::grid.newpage()
            grid::grid.draw(content)
          } else if (inherits(content, c("gg", "Heatmap"))) { # "Heatmap" S4 from ComplexHeatmap
            print(content)
          } else if (inherits(content, "trellis")) {
            grid::grid.newpage()
            grid::grid.draw(grid::grid.grabExpr(print(content), warn = 0, wrap.grobs = TRUE))
          }
          super$set_content(path)
        },
        finally = grDevices::dev.off()
      )
      invisible(self)
    },
    #' @description Sets the title of this `PictureBlock`.
    #'
    #' @details throws if argument is not `character(1)`.
    #'
    #' @param title (`character(1)`) a string assigned to this `PictureBlock`
    #'
    #' @return invisibly self
    set_title = function(title) {
      checkmate::assert_string(title)
      private$title <- title
      invisible(self)
    },
    #' @description Returns the title of this `PictureBlock`
    #'
    #' @return the content of this `PictureBlock`
    get_title = function() {
      private$title
    },
    #' @description Sets the dimensions of this `PictureBlock`
    #'
    #' @param dim `numeric` figure dimensions (width and height) in pixels, length 2.
    #'
    #' @return `self`
    set_dim = function(dim) {
      checkmate::assert_numeric(dim, len = 2)
      private$dim <- dim
      invisible(self)
    },
    #' @description Returns the dimensions of this `PictureBlock`
    #'
    #' @return `numeric` the array of 2 numeric values representing width and height in pixels.
    get_dim = function() {
      private$dim
    }
  ),
  private = list(
    supported_plots = c("ggplot", "grob", "trellis", "Heatmap"),
    type = character(0),
    title = "",
    dim = c(800, 600)
  ),
  lock_objects = TRUE,
  lock_class = TRUE
)
