require 'bundler'
Bundler.setup

require 'sinatra'
require 'rack/cache'

set :run, false
set :environment, ENV['RACK_ENV'].to_sym

use Rack::Cache,
  :verbose => true,
  :metastore   => 'file:/tmp',
  :entitystore => 'file:/tmp'

require './lib/server'
run Sinatra::Application
