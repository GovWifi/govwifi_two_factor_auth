ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment.rb", __dir__)
require "rspec/rails"
require "generator_spec"
require "rails/generators"
require "rspec/autorun"
require "timecop"
require "capybara/rails"
ENV["RAILS_ROOT"] = File.expand_path("../dummy")

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.use_transactional_examples = true

  config.include Capybara::DSL

  config.after(:each) { Timecop.return }

  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end
