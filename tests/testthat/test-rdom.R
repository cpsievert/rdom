context("rdom")

jsTable <- system.file("jsTable/jsTable.html", package = "rdom")

test_that("rdom can render DOM with client-side dynasism", {
  html <- rdom(jsTable)
  tab <- XML::getNodeSet(html, "//table")[[1]]
  df <- XML::readHTMLTable(tab)
  expect_equal(dim(df), c(3, 3))
})

test_that("rdom's css selector works", {
  tab <- rdom(jsTable, css = "table")
  df <- XML::readHTMLTable(tab)
  expect_equal(dim(df), c(3, 3))
})

test_that("rdom's querySelectorAll equivalent works", {
  trs <- rdom(jsTable, css = "tr", all = TRUE)
  expect_equal(length(trs) >= 3)
})

test_that("rdom writes to a local file", {
  f <- tempfile(fileext = ".html")
  html <- rdom(jsTable, filename = f)
  doc <- XML::htmlParse(f)
  tab <- XML::getNodeSet(doc, "//table")[[1]]
  df <- XML::readHTMLTable(tab)
  expect_equal(dim(df), c(3, 3))
})
