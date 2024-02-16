## -----------------------------------------------------------------------------
library(teal.reporter)
ui <- shiny::fluidPage(simple_reporter_ui("simple"))
server <- function(input, output, session) {
  # The bulk of your module logic here

  create_module_card <- function(card) {
    card$append_text("This is the content of the report from the `simple` module")
  }
  simple_reporter_srv("simple", Reporter$new(), create_module_card)
}

if (interactive()) shiny::shinyApp(ui, server)

