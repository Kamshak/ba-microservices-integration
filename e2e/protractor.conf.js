'use strict';
// An example configuration file.
exports.config = {
  // The address of a running selenium server.
  seleniumAddress: 'http://ondemand.saucelabs.com:80',
  //seleniumServerJar: deprecated, this should be set on node_modules/protractor/config.json
  sauceUser: process.env.SAUCE_USERNAME,
  sauceKey: process.env.SAUCE_ACCESS_KEY,

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    'browserName': 'chrome'
  },

  // Spec patterns are relative to the current working directly when
  // protractor is called.
  specs: ['tests/**/*.js'],

  // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  },

  onPrepare: function() {
    var caps = browser.getCapabilities()
  },

  multiCapabilities: [{
   browserName: 'firefox',
   version: '32',
   platform: 'OS X 10.10',
   name: "firefox-tests",
   shardTestFiles: true,
   maxInstances: 25
 }, {
   browserName: 'chrome',
   version: '41',
   platform: 'Windows 7',
   name: "chrome-tests",
   shardTestFiles: true,
   maxInstances: 25
 }],
};
