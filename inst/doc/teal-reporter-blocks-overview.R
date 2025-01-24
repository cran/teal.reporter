## ----load_mermaid, echo=FALSE-------------------------------------------------
shiny::tags$script(type = "module", "import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid/+esm'")

## ----actors_mermaid2, echo=FALSE----------------------------------------------
shiny::pre(
  class = "mermaid",
  "
%% This is a mermaid diagram, if you see this the plot failed to render. Sorry.
classDiagram
    class ReportCard{
      +append_content()
      +append_text()
      +append_table()
      +append_plot()
      +append_rcode()
      +append_metadata()
    }

    ReportCard <.. FileBlock: utilizes
    ReportCard <.. ContentBlock: utilizes
    ReportCard <.. TextBlock: utilizes
    ReportCard <.. NewpageBlock: utilizes
    ReportCard <.. RcodeBlock: utilizes
    ReportCard <.. PictureBlock: utilizes
    ReportCard <.. TableBlock: utilizes

    ContentBlock <|-- TextBlock
    ContentBlock <|-- NewpageBlock
    ContentBlock <|-- RcodeBlock
    ContentBlock <|-- FileBlock
    FileBlock <|-- PictureBlock
    FileBlock <|-- TableBlock


    namespace Blocks {
      class ContentBlock
      class FileBlock
      class TextBlock
      class NewpageBlock
      class RcodeBlock
      class PictureBlock
      class TableBlock
    }

style ContentBlock fill:lightpurple
style FileBlock fill: lightgreen
style TextBlock fill: pink
style NewpageBlock fill: pink
style RcodeBlock fill: pink
style PictureBlock fill: gold
style TableBlock fill:gold
style ReportCard fill:lightblue
"
)

## -----------------------------------------------------------------------------
library(teal.reporter)
getOption("teal.reporter.global_knitr")

## ----eval=requireNamespace("ggplot2")-----------------------------------------
library(ggplot2)

report_card <- ReportCard$new()

report_card$append_text("Header 2 text", "header2")
report_card$append_text("A paragraph of default text")
report_card$append_plot(
  ggplot(airquality, aes(x = Ozone, y = Solar.R)) +
    geom_line(na.rm = TRUE)
)
report_card$append_table(airquality)
report_card$append_rcode("airquality_new <- airquality", echo = FALSE)
report_card$append_metadata(key = "lm", value = lm(Ozone ~ Solar.R, airquality))
report_card$get_content()

