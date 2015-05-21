// TODO: provide a check for argument usage
var args = require('system').args;
var page = require('webpage').create();
var url = args[1];

page.open(url, function (status) {
  // TODO: include options to manipulate DOM and/or inject JS?
  // http://phantomjs.org/page-automation.html
    var doc = page.evaluate(function () {
        return document.documentElement.outerHTML;
    });
    console.log(doc);
    phantom.exit();
});
