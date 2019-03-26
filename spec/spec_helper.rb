require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'ffaker'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'spree/testing_support/factories'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/preferences'

FactoryBot.find_definitions

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec
  config.use_transactional_fixtures = true

  config.include Spree::TestingSupport::Preferences

  config.before do
    reset_spree_preferences
  end
end
