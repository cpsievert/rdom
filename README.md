rdom
=====

Easy access to the DOM of a webpage as HTML with phantomjs.

### Installation

**rdom** depends on [phantomjs](http://phantomjs.org/), so make sure that is installed and visible to your PATH:

```r
stopifnot(Sys.which("phantomjs") != "")
```

**rdom** currently isn't on CRAN, but you can install it with devtools

```r
devtools::install_github("cpsievert/rdom")
```

### Motivation

tl;dr - Swap out `rvest::html()` for `rdom::rdom()` when you need to scrape [dynamic web pages](http://en.wikipedia.org/wiki/Dynamic_web_page).

[**rvest**](http://cran.r-project.org/web/packages/rvest/index.html) is awesome for scraping content from HTML pages, but it can only download the page source (which is _static_) and many websites nowadays are _dynamic_. Unfortunately, unless you [read the page source](http://www.computerhope.com/issues/ch000746.htm), you probably won't notice the difference until you run a strange error. Here's an example where that difference matters.

For good reason, **rvest** has [a vignette on how to use it with SelectorGadget](http://cran.r-project.org/web/packages/rvest/vignettes/selectorgadget.html) to scrape content. Suppose I follow this guide in attempt to obtain the title 

```r
library(rvest)
article <- "http://www.sciencedirect.com/science/article/pii/S2214999615005342"
article %>% html() %>% html_node("#sec1")
```

```
NULL
```

What? Why?

```r
library(rdom)
article %>% rdom() %>% html_node("#sec1")
```

Here's an example of where this difference becomes important:



#### Scraping dynamic pages

Suppose you've found some information on a webpage that you'd like to extract.

With **rdom** and [**rvest**](http://cran.r-project.org/web/packages/rvest/), accessing and extracting DOM elements is a breeze:

```r
library("rvest")
library("rdom")
rdom("http://www.techstars.com/companies/stats/") %>%
   html_node(".table75") %>% html_table()
```


```r
    Status Number of Companies Percentage
1   Active                 399     76.15%
2 Acquired                  69     13.17%
3   Failed                  58     11.07%
```

```{r}
library("rvest")
library("rdom")
html("https://www.datatables.net/examples/data_sources/js_array.html") %>%
  html_node("#example") %>% html_table()
```

```{r}
rdom("https://www.datatables.net/examples/data_sources/js_array.html") %>%
  html_node("#example") %>% html_table()
```


Note that, by itself, **rvest** can't obtain this table since it isn't hard coded in the page source (the table is populated via JavaScript).

```r
library("rvest")
html("http://www.techstars.com/companies/stats/") %>%
   html_node(".table75") %>% html_table()
```

```r
Error in UseMethod("html_table") : 
  no applicable method for 'html_table' applied to an object of class "NULL"
```

#### Test your shiny apps

First, run your shiny app:

```r
library(shiny)
runExample("01_hello")
```

```r
Listening on http://127.0.0.1:4870
```

Now, in another R session, pass the shiny URL to `rdom()` and it will return the DOM as HTML.

```r
library("rvest")
(header <- rdom("http://127.0.0.1:4870") %>% html_node("h2") %>% html_text())
```

```r
[1] "Hello Shiny!"
```

This way it's fun and easy to test your shiny apps!

```r
library("testthat")
expect_identical(header, "Hello Shiny!")
```

### TODO

* An API for manipulating the DOM and injecting JS?

### Acknowledgements

Thanks to Winston Chang for [webshot](https://github.com/wch/webshot) which inspired the design of this package.
