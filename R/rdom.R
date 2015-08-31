#' Return DOM of a website as HTML
#'
#' @param url A url or a local path.
#' @param css a string containing one or more CSS selectors separated by commas.
#' @param all logical. This controls whether \code{querySelector} or
#' \code{querySelectorAll} is used to extract elements from the page.
#' When FALSE, output is similar to \code{rvest::html_node}. When TRUE,
#' output is similar to \code{rvest::html_nodes}.
#' If \code{css} is missing, then this argument is ignored.
#' @param timeout maximum time to wait for page to load and render, in seconds.
#' @param filename A character string specifying a filename to store result
#' @export
#' @examples
#' @importFrom XML htmlParse
#' @importFrom XML xmlChildren
#' @importFrom XML getNodeSet
#'
#' library("rvest")
#' stars <- "http://www.techstars.com/companies/stats/"
#' # doesn't work
#' html(stars) %>% html_node(".table75") %>% html_table()
#' # should work
#' rdom(stars) %>% html_node(".table75") %>% html_table()
#' # more efficient
#' stars %>% rdom(".table75") %>% html_table()
#'

rdom <- function(url, css, all, timeout, filename) {
  if (missing(url)) stop('Please specify a url.')
  args <- list(
    system.file('rdomjs/rdom.js', package = 'rdom'),
    url,
    # NA is a nice default since jsonlite::toJSON(NA) == null
    css %||% NA,
    all %||% FALSE,
    timeout %||% 5,
    filename %||% NA
  )
  args <- lapply(args, jsonlite::toJSON, auto_unbox = TRUE)
  phantom_bin <- find_phantom()
  res <- if (missing(filename)) {
    # capture output as a character vector
    system2(phantom_bin, args = as.character(args),
            stdout = TRUE, stderr = TRUE, wait = TRUE)
  } else {
    # ignore stdout/stderr and write to file
    system2(phantom_bin, args = as.character(args),
            stdout = FALSE, stderr = FALSE, wait = TRUE)
  }
  st <- attr(res, 'status')
  if (!is.null(st)) stop(paste(res, '\n'))
  p <- if (missing(filename)) {
    XML::htmlParse(res, asText = TRUE)
  } else {
    XML::htmlParse(filename)
  }
  # If the result is a node or node list, htmlParse() inserts them into
  # the body of a bare-bones HTML page.
  if (!missing(css)) {
    nodes <- XML::xmlChildren(XML::getNodeSet(p, '//body')[[1]])
    if (length(nodes) == 1) nodes[[1]] else nodes
  } else {
    p
  }
}
