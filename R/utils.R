# Much of this file is copied/adapted from Winston Chang's work

phantom_run <- function(args, wait = TRUE) {
  phantom_bin <- find_phantom()
  system2(phantom_bin, args = as.character(args), stdout = TRUE, wait = wait)
}

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
  invisible(pjs)
}

# Given a vector or list, drop all the NULL items in it
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}
