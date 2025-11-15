## ----basic-usage--------------------------------------------------------------
library(teal.reporter)
report <- teal_report()

## -----------------------------------------------------------------------------
teal_card(report) <- c(
  teal_card(report),
  "## Document section",
  "Lorem ipsum dolor sit amet"
)

teal_card(report)

## -----------------------------------------------------------------------------
report <- within(report, {
  a <- 2
})
report$a
teal_card(report)

## -----------------------------------------------------------------------------
report <- within(report, {
  head_of_iris <- head(iris)
  head_of_iris
})

teal.code::get_outputs(report) # returns a list of all outputs

## -----------------------------------------------------------------------------
# adding element at the beginning of the document
teal_card(report) <- c(teal_card("# My report"), teal_card(report))

# removing code_chunk(s)
teal_card(report) <- Filter(
  function(x) !inherits(x, "code_chunk"),
  teal_card(report)
)

# replace an element
teal_card(report)[[1]] <- "# My report (replaced)"

teal_card(report)

## -----------------------------------------------------------------------------
metadata(teal_card(report)) <- list(
  title = "My Document",
  author = "NEST"
)

## ----eval=FALSE---------------------------------------------------------------
# tools::toHTML(report)

## ----eval=FALSE---------------------------------------------------------------
# render(report, output_format = rmarkdown::pdf_document(), global_knitr = list(fig.width = 10))

