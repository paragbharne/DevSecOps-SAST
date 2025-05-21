module.exports = {
  moduleFileExtensions: ['js', 'vue'],
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest'
  },
  collectCoverage: true,
  collectCoverageFrom: ['components/**/*.vue', 'pages/**/*.vue'],
  coverageReporters: ['lcov', 'text-summary']
}
