% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Renderer.R
\name{Renderer}
\alias{Renderer}
\title{\code{Renderer}}
\description{
\code{Renderer}

\code{Renderer}
}
\keyword{internal}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Renderer-new}{\code{Renderer$new()}}
\item \href{#method-Renderer-finalize}{\code{Renderer$finalize()}}
\item \href{#method-Renderer-renderRmd}{\code{Renderer$renderRmd()}}
\item \href{#method-Renderer-render}{\code{Renderer$render()}}
\item \href{#method-Renderer-get_output_dir}{\code{Renderer$get_output_dir()}}
\item \href{#method-Renderer-clone}{\code{Renderer$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-new"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-new}{}}}
\subsection{Method \code{new()}}{
Returns a \code{Renderer} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$new()}\if{html}{\out{</div>}}
}

\subsection{Details}{
Returns a \code{Renderer} object.
}

\subsection{Returns}{
\code{Renderer} object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-finalize"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-finalize}{}}}
\subsection{Method \code{finalize()}}{
Finalizes a \code{Renderer} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$finalize()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-renderRmd"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-renderRmd}{}}}
\subsection{Method \code{renderRmd()}}{
getting the \code{Rmd} text which could be easily rendered later.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$renderRmd(blocks, yaml_header, global_knitr = list())}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{blocks}}{\code{list} of \code{c("TextBlock", "PictureBlock", "NewpageBlock")} objects.}

\item{\code{yaml_header}}{\code{character} a \code{rmarkdown} \code{yaml} header.}

\item{\code{global_knitr}}{\code{list} a global \code{knitr} parameters, like echo.
But if local parameter is set it will have priority.
Defaults to empty \code{list()}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{character} a \code{Rmd} text (\code{yaml} header + body), ready to be rendered.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-render"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-render}{}}}
\subsection{Method \code{render()}}{
Renders the content of this \code{Report} to the output file
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$render(blocks, yaml_header, global_knitr = list(), ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{blocks}}{\code{list} of \code{c("TextBlock", "PictureBlock", "NewpageBlock")} objects.}

\item{\code{yaml_header}}{\code{character} an \code{rmarkdown} \code{yaml} header.}

\item{\code{global_knitr}}{\code{list} a global \code{knitr} parameters, like echo.
But if local parameter is set it will have priority.
Defaults to empty \code{list()}.}

\item{\code{...}}{\code{rmarkdown::render} arguments, \code{input} and \code{output_dir} should not be updated.z}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{character} path to the output
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-get_output_dir"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-get_output_dir}{}}}
\subsection{Method \code{get_output_dir()}}{
get \code{output_dir} field
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$get_output_dir()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{character} a \code{output_dir} field path.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Renderer-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Renderer-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Renderer$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
