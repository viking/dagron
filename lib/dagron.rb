require 'sinatra/base'
require 'sequel'
require 'erb'
require 'yaml'
require 'pathname'
require 'logger'
require 'json'

module Dagron
  Root = (Pathname.new(File.dirname(__FILE__)) + '..').expand_path
  Env = ENV['RACK_ENV'] || 'development'

  config_path = Root + 'config' + 'database.yml'
  config_tmpl = ERB.new(File.read(config_path))
  config_tmpl.filename = config_path.to_s
  Config = YAML.load(config_tmpl.result(binding))

  db_config = Config[Env]
  if db_config['logger']
    file = config['logger']
    db_config['logger'] = Logger.new(file == '_stderr_' ? STDERR : file)
  end
  Database = Sequel.connect(db_config)
end

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :json_serializer

require "dagron/version"
require "dagron/map"
require "dagron/image"
require "dagron/application"
