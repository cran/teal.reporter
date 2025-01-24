## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message = FALSE, eval=requireNamespace("ggplot2")------------------------
library(shiny)
library(teal.reporter)
library(ggplot2)
library(rtables)

## ----eval=requireNamespace("ggplot2")-----------------------------------------
ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      uiOutput("encoding")
    ),
    mainPanel(
      ### REPORTER
      tags$div(
        add_card_button_ui("addReportCard"),
        download_report_button_ui("downloadButton"),
        reset_report_button_ui("resetButton")
      ),
      ###
      tags$br(),
      tabsetPanel(
        id = "tabs",
        tabPanel("Plot", plotOutput("dist_plot")),
        tabPanel("Table", verbatimTextOutput("table"))
      )
    )
  )
)

server <- function(input, output, session) {
  output$encoding <- renderUI({
    if (input$tabs == "Plot") {
      sliderInput(
        "binwidth",
        "binwidth",
        min = 2,
        max = 10,
        value = 8
      )
    } else {
      selectInput(
        "stat",
        label = "Statistic",
        choices = c("mean", "median", "sd"),
        "mean"
      )
    }
  })

  plot <- reactive({
    req(input$binwidth)
    x <- mtcars$mpg
    ggplot(data = mtcars, aes(x = mpg)) +
      geom_histogram(binwidth = input$binwidth)
  })

  output$dist_plot <- renderPlot({
    plot()
  })

  table <- reactive({
    req(input$stat)
    lyt <- basic_table() %>%
      split_rows_by("Month", label_pos = "visible") %>%
      analyze("Ozone", afun = eval(str2expression(input$stat)))

    build_table(lyt, airquality)
  })

  output$table <- renderPrint({
    table()
  })

  ### REPORTER
  reporter <- Reporter$new()
  card_fun <- function(card = ReportCard$new(), comment) {
    if (input$tabs == "Plot") {
      card$append_text("My plot", "header2")
      card$append_plot(plot())
    } else if (input$tabs == "Table") {
      card$append_text("My Table", "header2")
      card$append_table(table())
    }
    if (!comment == "") {
      card$append_text("Comment", "header3")
      card$append_text(comment)
    }
    card
  }

  add_card_button_srv("addReportCard", reporter = reporter, card_fun = card_fun)
  download_report_button_srv("downloadButton", reporter = reporter)
  reset_report_button_srv("resetButton", reporter)
  ###
}

if (interactive()) shinyApp(ui = ui, server = server)

## ----eval=requireNamespace("ggplot2")-----------------------------------------
ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      uiOutput("encoding")
    ),
    mainPanel(
      ### REPORTER
      simple_reporter_ui("simpleReporter"),
      ###
      tabsetPanel(
        id = "tabs",
        tabPanel("Plot", plotOutput("dist_plot")),
        tabPanel("Table", verbatimTextOutput("table"))
      )
    )
  )
)

server <- function(input, output, session) {
  output$encoding <- renderUI({
    if (input$tabs == "Plot") {
      sliderInput(
        "binwidth",
        "binwidth",
        min = 2,
        max = 10,
        value = 8
      )
    } else {
      selectInput(
        "stat",
        label = "Statistic",
        choices = c("mean", "median", "sd"),
        "mean"
      )
    }
  })

  plot <- reactive({
    req(input$binwidth)
    x <- mtcars$mpg
    ggplot(data = mtcars, aes(x = mpg)) +
      geom_histogram(binwidth = input$binwidth)
  })

  output$dist_plot <- renderPlot({
    plot()
  })

  table <- reactive({
    req(input$stat)
    lyt <- basic_table() %>%
      split_rows_by("Month", label_pos = "visible") %>%
      analyze("Ozone", afun = eval(str2expression(input$stat)))

    build_table(lyt, airquality)
  })

  output$table <- renderPrint({
    table()
  })

  ### REPORTER
  reporter <- Reporter$new()

  # Optionally set reporter id to e.g. secure report reload only for the same app
  # The id is added to the downloaded file name.
  reporter$set_id("myappid")

  card_fun <- function(card = ReportCard$new(), comment) {
    if (input$tabs == "Plot") {
      card$append_text("My plot", "header2")
      card$append_plot(plot())
    } else if (input$tabs == "Table") {
      card$append_text("My Table", "header2")
      card$append_table(table())
    }
    if (!comment == "") {
      card$append_text("Comment", "header3")
      card$append_text(comment)
    }
    card
  }

  simple_reporter_srv("simpleReporter", reporter = reporter, card_fun = card_fun)
  ###
}

if (interactive()) shinyApp(ui = ui, server = server)

