## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message = FALSE----------------------------------------------------------
library(shiny)
library(teal.reporter)
library(ggplot2)
library(rtables)

## -----------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      uiOutput("encoding")
    ),
    mainPanel(
      ### REPORTER
      shiny::tags$div(
        teal.reporter::add_card_button_ui("addReportCard"),
        teal.reporter::download_report_button_ui("downloadButton"),
        teal.reporter::reset_report_button_ui("resetButton")
      ),
      ###
      shiny::tags$br(),
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
    ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg)) +
      ggplot2::geom_histogram(binwidth = input$binwidth)
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
  reporter <- teal.reporter::Reporter$new()
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

  teal.reporter::add_card_button_srv("addReportCard", reporter = reporter, card_fun = card_fun)
  teal.reporter::download_report_button_srv("downloadButton", reporter = reporter)
  teal.reporter::reset_report_button_srv("resetButton", reporter)
  ###
}

if (interactive()) shinyApp(ui = ui, server = server)

## -----------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      uiOutput("encoding")
    ),
    mainPanel(
      ### REPORTER
      teal.reporter::simple_reporter_ui("simpleReporter"),
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
    ggplot2::ggplot(data = mtcars, ggplot2::aes(x = mpg)) +
      ggplot2::geom_histogram(binwidth = input$binwidth)
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
  reporter <- teal.reporter::Reporter$new()
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

  teal.reporter::simple_reporter_srv("simpleReporter", reporter = reporter, card_fun = card_fun)
  ###
}

if (interactive()) shinyApp(ui = ui, server = server)

