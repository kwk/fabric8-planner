Error.stackTraceLimit = 30;

require('core-js/es6');
require('core-js/es7/reflect');
require('reflect-metadata');
require('ts-helpers');
require('zone.js/dist/zone');
require('zone.js/dist/long-stack-trace-zone');
require('zone.js/dist/sync-test');
require('zone.js/dist/async-test');
require('zone.js/dist/fake-async-test');
require('zone.js/dist/sync-test');
require('zone.js/dist/proxy'); // since zone.js 0.6.15
require('zone.js/dist/jasmine-patch'); // put here since zone.js 0.6.14

require('rxjs/Rx');

var testing = require('@angular/core/testing');
var browser = require('@angular/platform-browser-dynamic/testing');

var appContext = require.context('./../src', true, /\.spec\.ts/);
function requireAll(requireContext) {
  return requireContext.keys().map(requireContext);
}
var modules = requireAll(appContext);

testing.TestBed.initTestEnvironment(
  browser.BrowserDynamicTestingModule,
  browser.platformBrowserDynamicTesting()
);