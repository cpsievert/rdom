rdom
=====

Render and parse the DOM from R via phantomjs.

### Installation

**rdom** depends on [phantomjs](http://phantomjs.org/), so make sure that is installed and visible to your PATH:

```r
stopifnot(Sys.which("phantomjs") != "")
```

**rdom** currently isn't on CRAN, but you can install it with devtools

```r
devtools::install_github("cpsievert/rdom")
```

### Introduction

Web scraping packages such as [__XML__](http://cran.r-project.org/web/packages/XML/index.html), [__xml2__](http://cran.r-project.org/web/packages/xml2/index.html) and [__rvest__](http://cran.r-project.org/web/packages/rvest/) allow you to download and _parse_ HTML files, but they lack a [browsing engine](https://en.wikipedia.org/wiki/Web_browser_engine) to fully render [the DOM](https://en.wikipedia.org/wiki/Document_Object_Model). 

To demonstrate the difference, suppose we want to extract the HTML table on [this page](http://bl.ocks.org/cpsievert/raw/2a9fb8f504cd56e9e8e3/):

![](http://imgur.com/bsLODlC)

`XML::htmlParse()` (and `rvest::read_html()`) returns the HTML page source, which is static, and doesn't contain the `<table>` element we desire (because JavaScript is modifying the state of the DOM):

```r
XML::htmlParse("http://bl.ocks.org/cpsievert/raw/2a9fb8f504cd56e9e8e3/")
```

```html
<!DOCTYPE html>
<html><body>
    A Simple Table made with JavaScript
    <p></p>
    <script>
      function tableCreate(){
        var body = document.body,
          tbl  = document.createElement('table');

        for(var i = 0; i < 3; i++){
          var tr = tbl.insertRow();
          for(var j = 0; j < 3; j++){
            var td = tr.insertCell();
            td.appendChild(document.createTextNode("Cell"));
          }
        }
        body.appendChild(tbl);
      }
      tableCreate();
    </script>
</body></html>
```

The main function in __rdom__, `rdom()`, uses phantomjs to render and return the DOM as an HTML string. Instead of passing the entire DOM as a string from phantomjs to R, you can give `rdom()` a CSS Selector to extract certain element(s).

```r
rdom::rdom("http://bl.ocks.org/cpsievert/raw/2a9fb8f504cd56e9e8e3/", 
           css = "table")
```

```html
<table>
  <tbody>
    <tr>
      <td>Cell</td>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <td>Cell</td>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
    <tr>
      <td>Cell</td>
      <td>Cell</td>
      <td>Cell</td>
    </tr>
  </tbody>
</table> 
```

### Render shiny apps

An interesting use case for __rdom__ is for rendering (and testing) shiny apps.

```r
library(shiny)
runExample("01_hello")
```

```r
Listening on http://127.0.0.1:4870
```

Now, in another R session, pass this URL to `rdom()`. For this example, we'll just return the app's title.

```r
header <- rdom::rdom("http://127.0.0.1:4870", "h2")
```

```r
<h2>Hello Shiny!</h2>
```

This way it's easy to test your shiny apps!

```r
library("testthat")
expect_identical(XML::xmlValue(header), "Hello Shiny!")
```


### Using the CLI

`rdom()` is essentially a wrapper around [phantomjs' command line interface](http://phantomjs.org/api/command-line.html). So, if you don't need R for your task, it might be more efficient to use the CLI. 

```
$ git clone https://github.com/cpsievert/rdom.git
$ cd rdom
$ phantomjs inst/rdom.js http://bl.ocks.org/cpsievert/raw/2a9fb8f504cd56e9e8e3 10000 table
```

There are 4 arguments that the `inst/rdom.js` script will respect:

1. `url` a URL of a web page (required)
2. `timeout` maximum time to wait for page to load and render, in milliseconds. (required)
3. `css` a CSS selector (optional)
4. `all` This controls whether querySelector or querySelectorAll is used to extract elements from the page. (optional)


Everytime you call `rdom()`, it has to initiate a phantomjs process. Also, phantomjs has to open and fully render the site that you provide. If you need to render multiple sites, 


### Acknowledgements

Thanks to Winston Chang for [webshot](https://github.com/wch/webshot) which inspired the design of this package.
