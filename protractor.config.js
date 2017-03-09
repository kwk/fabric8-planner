exports.config = {
  useAllAngular2AppRoots: true,
  getPageTimeout: 30000,
  seleniumAddress: 'http://localhost:4444/wd/hub',
  specs: ['src/tests/**/*smokeTest.spec.js'],
  exclude: [
    'src/tests/**/TBD/*.spec.js', 'src/tests/**/orderOfExecution.spec.js',
    'src/tests/**/work-item-timeStamp.spec.js',
    'src/tests/**/testHelpers*.spec.js'
  ],
  suites: {smokeTest: 'src/tests/**/smokeTest.spec.js'},
  jasmineNodeOpts: {defaultTimeoutInterval: 60000},

  capabilities: {
    'browserName': 'chrome',
    'chromeOptions': {'args': ['no-sandbox']}
    // 'browserName': 'phantomjs',
    //   'maxInstances': 2,
    //   'shardTestFiles': true,
    //   'phantomjs.binary.path': require('phantomjs-prebuilt').path,
    //   'phantomjs.cli.args': ['--webdriver-loglevel=ERROR',
    //   '--local-storage-path=/tmp/phantom_' + Math.random()]

  }
};