process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const { webpackConfig, merge } = require('@rails/webpacker')
const environment = require('./environment')

module.exports = merge(webpackConfig, environment)