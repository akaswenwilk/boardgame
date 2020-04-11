# frozen_string_literal: true

require_relative "./config/initializers/base.rb"

class App < Hanami::API
  get "/" do
    "Hello, world"
  end
end

run App.new
