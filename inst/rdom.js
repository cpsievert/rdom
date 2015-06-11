// TODO: include options to manipulate DOM and/or inject JS?
var page = require('webpage').create();
// TODO: provide a check for argument usage
var args = require('system').args;
var selector = {"value": args[3], "all": args[4]};

page.open(args[1], function (status) {
  if (status !== 'success') {
    console.log("phantomjs couldn't open the page.");
    phantom.exit();
  } else {
    // http://stackoverflow.com/questions/28950627/settimeout-in-phantom-js
    setTimeout(function() {
      // http://phantomjs.org/api/webpage/method/evaluate.html
      var el = page.evaluate(function f(s) {
        // if selector is invalid, return the entire document
        if (s.value === undefined) {
          return document.documentElement.outerHTML;
        // default to querySelector (over querySelectorAll)
        } else if (s.all === undefined || s.all == "false") {
          return document.querySelector(s.value).outerHTML;
        } else {
          var nodeList = document.querySelectorAll(s.value);
          var html = [];
          for (var i = 0; i < nodeList.length; i++) {
            html.push(nodeList[i].outerHTML);
          }
          return html
        }
      }, selector);
      console.log(el);
      phantom.exit();
    }, args[2]);
  }
});

