# Try really hard to find bower in Windows
find_phantom <- function() {
  # a slightly more robust finder of bower for windows
  # which does not require PATH environment variable to be set
  pjs <- Sys.which("phantomjs")
  if (pjs == "" && identical(.Platform$OS.type, "windows"))
    pjs <- Sys.which(file.path(Sys.getenv("APPDATA"), "npm", "phantomjs.cmd"))
  if (pjs == "")
    stop("phantomjs not found in path. phantomjs must be installed and in path.",
         call. = FALSE)
  invisible(as.character(pjs))
}

"%||%" <- function(x, y = NULL) {
  if (missing(x)) y else x
}

"%pe%" <- function(x, y = "") {
  if (missing(x)) y else path.expand(x)
}
