## ----message = FALSE----------------------------------------------------------
library(shiny)
library(teal.reporter)

## ----eval = interactive()-----------------------------------------------------
# ui <- bslib::page_fluid(
#   bslib::card(
#     bslib::card_header("Reporter Modules Demo"),
#     bslib::layout_sidebar(
#       sidebar = bslib::sidebar(
#         ### REPORTER
#         teal.reporter::add_card_button_ui("add_card", label = "Add Card"),
#         teal.reporter::preview_report_button_ui("preview"),
#         teal.reporter::download_report_button_ui("download", label = "Download"),
#         teal.reporter::report_load_ui("load", label = "Load"),
#         teal.reporter::reset_report_button_ui("reset", label = "Reset"),
#         ###
#       ),
#       bslib::card(
#         bslib::card_header("Summary Statistics by Cylinder"),
#         selectInput(
#           "stat",
#           label = "Select Statistic:",
#           choices = c("mean", "median", "sd"),
#           selected = "mean"
#         ),
#         tableOutput("table")
#       )
#     )
#   )
# )
# 
# server <- function(input, output, session) {
#   # Here we start with empty teal_report object
#   data <- teal_report()
# 
#   # Create summary table
#   with_summary_table <- reactive({
#     req(input$stat)
#     # Add section's header with dynamic content
#     teal_card(data) <- c(teal_card(data), paste("## Summary Statistics:", input$stat))
# 
#     # Execute dynamically generated code (this stores evaluated code-chunk and its output)
#     within(
#       data,
#       expr = {
#         summary_table <- data.frame(
#           cyl = sort(unique(mtcars$cyl)),
#           mpg = tapply(mtcars$mpg, mtcars$cyl, stat_fun),
#           hp = tapply(mtcars$hp, mtcars$cyl, stat_fun),
#           wt = tapply(mtcars$wt, mtcars$cyl, stat_fun)
#         )
#         summary_table
#       },
#       stat_fun = as.name(input$stat)
#     )
#   })
# 
#   output$table <- renderTable({
#     # extract `summary_table` from teal_report object
#     teal.code::get_outputs(with_summary_table())[[1]]
#   })
# 
#   ### REPORTER
#   reporter <- Reporter$new()
#   reporter$set_id("reporter_demo")
# 
#   # extract teal_card object and hand it over to add_card_button_srv
#   card_r <- reactive(teal_card(with_summary_table()))
#   teal.reporter::add_card_button_srv("add_card", reporter = reporter, card_fun = card_r)
#   teal.reporter::preview_report_button_srv("preview", reporter)
#   teal.reporter::download_report_button_srv("download", reporter)
#   teal.reporter::report_load_srv("load", reporter)
#   teal.reporter::reset_report_button_srv("reset", reporter)
#   ###
# }
# 
# shinyApp(ui = ui, server = server)

