require 'sinatra/base'
require 'sequel'
require 'erb'
require 'yaml'
require 'pathname'
require 'logger'

module Dagron
  Root = (Pathname.new(File.dirname(__FILE__)) + '..').expand_path
  Env = ENV['RACK_ENV'] || 'development'

  config_path = Root + 'config' + 'database.yml'
  config_tmpl = ERB.new(File.read(config_path))
  config_tmpl.filename = config_path.to_s
  config = YAML.load(config_tmpl.result(binding))[Env]
  if config['logger']
    file = config['logger']
    config['logger'] = Logger.new(file == '_stderr_' ? STDERR : file)
  end
  Database = Sequel.connect(config)
end

Sequel::Model.plugin :validation_helpers

require "dagron/version"
require "dagron/map"
require "dagron/application"
