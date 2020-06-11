require "bundler/setup"
require "hanami/api"
require 'hanami/middleware/body_parser'
require "hanami/logger"
require "pry"
require "pry-nav"
require "active_support/all"
require "oj"
require_relative "./errors.rb"
require_relative "./database.rb"

Dir[File.join(Dir.pwd, "app", "**", "*.rb")].sort.each { |file| require(file) }
