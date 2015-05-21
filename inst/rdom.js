// TODO: include options to manipulate DOM and/or inject JS?
var page = require('webpage').create();
// TODO: provide a check for argument usage
var args = require('system').args;
var url = args[1];

page.open(url, function (status) {
  if (status !== 'success') {
    console.log("phantomjs couldn't open the page.");
    phantom.exit();
  } else {
    // Get phantomjs 10 seconds to evaluate the page
    // http://stackoverflow.com/questions/28950627/settimeout-in-phantom-js
    setTimeout(function() {
      var doc = page.evaluate(function () {
        return document.documentElement.outerHTML;
      });
      console.log(doc);
      phantom.exit();
    }, 10000);
  }
});

