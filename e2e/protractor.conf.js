'use strict';
// An example configuration file.
exports.config = {
  // The address of a running selenium server.
  // seleniumAddress: 'http://ondemand.saucelabs.com:80/wd/hub',
  sauceUser: process.env.SAUCE_USERNAME,
  sauceKey: process.env.SAUCE_ACCESS_KEY,

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

  onComplete: function() {
    var printSessionId = function(jobName){
      browser.getSession().then(function(session) {
        console.log('SauceOnDemandSessionID=' + session.getId() + ' job-name=' + jobName);
      });
    }
    printSessionId("E2E");
  },

  capabilities: {
    'browserName': 'chrome',
    //'tunnel-identifier': process.env.TRAVIS_JOB_NUMBER,
    'build': process.env.TRAVIS_BUILD_NUMBER,
    'name': 'End to End'
  }
};
