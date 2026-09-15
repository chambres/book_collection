require "spec_helper"
require "simplecov"
SimpleCov.start "rails"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort "Do not run specs in production" if Rails.env.production?
require "rspec/rails"
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
end
