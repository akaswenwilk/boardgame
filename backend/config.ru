# frozen_string_literal: true

require "bundler/setup"
require "hanami/api"
require_relative "config/initializers/database.rb"

class App < Hanami::API
  get "/" do
    "Hello, world"
  end
end

run App.new
