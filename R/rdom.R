#' Return DOM of a website as HTML
#'
#' @param url a URL of a website.
#' @export
#' @examples
#'
#' library("rvest")
#' html("http://www.techstars.com/companies/stats/") %>%
#'   html_node(".table75") %>% html_table()
#' t <- rdom("http://www.techstars.com/companies/stats/")
#' t %>% html_node(".table75") %>% html_table()
#' rdom("http://www.techstars.com/companies/stats/") %>% html_node(".table75") %>% html_table()
#' rdom("http://www.google.org/")
#'

rdom <- function(url) {
  if (missing(url)) stop("Please specify a url.")
  args <- list(
    paste0("'", system.file("rdom.js", package = "rdom"), "'"),
    url
  )
  phantom_bin <- find_phantom()
  res <- system2(phantom_bin, args = as.character(args),
                 stdout = TRUE, stderr = TRUE, wait = TRUE)
  st <- attr(res, "status")
  if (!is.null(st)) stop("phantomjs returned failure value: ", st)
  XML::htmlParse(res, asText = TRUE)
}
