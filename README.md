rdom
=====

Access the DOM of a webpage as HTML with phantomjs.

### Installation

**rdom** depends on [phantomjs](http://phantomjs.org/), so make sure that is installed and visible to your PATH:

```r
Sys.which("phantomjs")
```

**rdom** currently isn't on CRAN, but you can install it with devtools

```r
devtools::install_github("cpsievert/rdom")
```

### Use cases

#### Scraping dynamic pages

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


Note that the usual **rvest** approach can't find this table since the page is dynamic (the table is populated via JavaScript).

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
rdom("http://127.0.0.1:4870") %>% html_node("h2")
```

```r
<h2>Hello Shiny!</h2>
```

### TODO

* An API for manipulating the DOM and injecting JS?
