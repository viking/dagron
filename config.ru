require 'rubygems'
require 'bundler'

Bundler.require

require './lib/dagron'
run Dagron::Application
