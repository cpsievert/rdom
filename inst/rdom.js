// TODO: provide a check for argument usage
var args = require('system').args;
var page = require('webpage').create();
var url = args[1];

page.open(url, function (status) {
  // TODO: include options to manipulate DOM and/or inject JS?
  // http://phantomjs.org/page-automation.html
    var js = page.evaluate(function () {
        return document;
    });
    console.log(js.all[0].outerHTML);
    phantom.exit();
});
