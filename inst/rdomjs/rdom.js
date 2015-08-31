// TODO: include options to manipulate DOM and/or inject JS?
var page = require('webpage').create();
var sys = require('system');
var fs = require('fs');
// TODO: better checks for argument usage
var selector = {
  "value": sys.args[2],
  "all": sys.args[3]
};

// if timeout is not a number, default to 5 seconds
var timeout = +sys.args[4];
if (typeof timeout != "number") {
  timeout = 5000;
} else {
  // setTimeout() is in milliseconds, but I want seconds
  timeout = timeout * 1000;
}


// For a missing argument, typeof argument == "undefined"
// If explicitly pass null as an argument value, typeof argument == "string"
// That is why we do (argument === undefined || argument == "null") to check
// for missing-ness
/*
console.log(sys.args[1]); //url
console.log(sys.args[2]); //css
console.log(sys.args[3]); //all
console.log(sys.args[4]); //timeout
console.log(sys.args[5]); //filename
*/

page.open(sys.args[1], function (status) {
  if (status !== 'success') {
    sys.stderr.write("phantomjs couldn't open the page -> " + sys.args[1] + "\n");
    phantom.exit(1);
  } else {
    // http://stackoverflow.com/questions/28950627/settimeout-in-phantom-js
    setTimeout(function() {
      // http://phantomjs.org/api/webpage/method/evaluate.html
      var el = page.evaluate(function f(s) {
        // if selector is invalid, return the entire document
        if (s.value === undefined || s.value == "null") {
          return document.documentElement.outerHTML;
        // default to querySelector (over querySelectorAll)
        } else if (s.all === undefined || s.all == "null" || s.all == "false") {
          return document.querySelector(s.value).outerHTML;
        } else {
          var nodeList = document.querySelectorAll(s.value);
          var html = [];
          for (var i = 0; i < nodeList.length; i++) {
            html.push(nodeList[i].outerHTML);
          }
          return html;
        }
      }, selector);
      // write to file if specified; otherwise to stdout
      if (sys.args[5] === undefined || sys.args[5] == "null") {
        sys.stdout.write(el);
      } else {
        try {
         fs.write(sys.args[5], el, 'w');
        } catch(e) {
          console.log(e);
        }
      }
      phantom.exit(0);
    }, timeout);
  }
});

