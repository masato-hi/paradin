require "bundler/setup"
require "paradin"

ENV["RAILS_ENV"] ||= "test"
require "rails"
require "active_record/railtie"

module Paradin
  class Application < Rails::Application
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end

Rails.application.initialize!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
