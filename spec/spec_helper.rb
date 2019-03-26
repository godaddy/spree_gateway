require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'ffaker'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 60.seconds)
end
Capybara.javascript_driver = :poltergeist

require 'spree/testing_support/factories'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/preferences'

FactoryBot.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  #config.filter_run focus: true
  #config.filter_run_excluding slow: true

  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::Preferences

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    reset_spree_preferences
  end

  config.after do
    DatabaseCleaner.clean
  end

  Capybara.javascript_driver = :poltergeist
end
