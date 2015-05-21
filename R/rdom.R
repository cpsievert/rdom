#' Return DOM of a website as HTML
#'
#' @param url a URL of a website.
#' @param timeout maximum time to wait for page to load and render, in seconds
#' @export
#' @examples
#'
#' library("rvest")
#' # doesn't work
#' html("http://www.techstars.com/companies/stats/") %>%
#'   html_node(".table75") %>% html_table()
#' # should work
#' rdom("http://www.techstars.com/companies/stats/") %>%
#'   html_node(".table75") %>% html_table()
#'

rdom <- function(url, timeout=10) {
  if (missing(url)) stop("Please specify a url.")
  args <- list(
    paste0("'", system.file("rdom.js", package = "rdom"), "'"),
    url,
    timeout*1000
  )
  phantom_bin <- find_phantom()
  res <- system2(phantom_bin, args = as.character(args),
                 stdout = TRUE, stderr = TRUE, wait = TRUE)
  st <- attr(res, "status")
  if (!is.null(st)) {
    message("Uh oh, something went wrong :", paste(res, "\n"))
    stop("phantomjs returned failure value: ", st)
  }
  XML::htmlParse(res, asText = TRUE)
}
