var path = require("path");

try {
    require("source-map-support").install();
} catch(err) {
	console.warn('no source map support detected. Try running "npm install source-map-support"');
}

// cljs uses google closure
require(path.join(path.resolve("."),"../dist/node","goog","bootstrap","nodejs.js"));
require(path.join(path.resolve("."),"../dist/node","cljs_deps.js"));

goog.require('common.lib');

console.log(common.lib.hello.call(null, "node"));