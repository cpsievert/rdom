#' Return DOM of a website as HTML
#'
#' @param url a URL of a website.
#' @param css a string containing one or more CSS selectors separated by commas.
#' @param all logical. This controls whether \code{querySelector} or
#' \code{querySelectorAll} is used to extract elements from the page.
#' When FALSE, output is similar to \code{rvest::html_node}. When TRUE,
#' output is similar to \code{rvest::html_nodes}.
#' If \code{css} is missing, then this argument is ignored.
#' @param timeout maximum time to wait for page to load and render, in seconds.
#' @export
#' @examples
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

rdom <- function(url = NULL, css = NULL, all = FALSE, timeout = 5) {
  if (is.null(url)) stop("Please specify a url.")
  # If css is defined, convert R's TRUE/FALSE to true/false
  all <- if (is.null(css)) NULL else jsonlite::toJSON(all, auto_unbox = TRUE)
  args <- dropNulls(list(
    shQuote(system.file("rdom.js", package = "rdom")),
    url,
    timeout * 1000,
    css,
    all
  ))
  phantom_bin <- find_phantom()
  res <- system2(phantom_bin, args = as.character(args),
                 stdout = TRUE, stderr = TRUE, wait = TRUE)
  st <- attr(res, "status")
  if (!is.null(st)) {
    message("Uh oh, something went wrong :", paste(res, "\n"))
    stop("system2 returned status code of: ", st)
  }
  if (all(res %in% "phantomjs couldn't open the page.")) stop(res)
  p <- XML::htmlParse(res, asText = TRUE)
  # If the result is a node or node list, htmlParse() inserts them into
  # the body of a bare-bones HTML page.
  if (!is.null(css)) {
    nodes <- XML::xmlChildren(XML::getNodeSet(p, "//body")[[1]])
    if (length(nodes) == 1) nodes[[1]] else nodes
  } else {
    p
  }
}
