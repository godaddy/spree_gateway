# coding: utf-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gateway'
  s.version     = '5.0.0'
  s.summary     = 'Additional Payment Gateways for Spree Commerce'
  s.description = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author       = 'Spree Commerce'
  s.email        = 'gems@spreecommerce.com'
  s.homepage     = 'http://www.spreecommerce.com'
  s.license      = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0.0'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'coffee-rails', '~> 4.2.0'
  s.add_development_dependency 'simplecov', '~> 0.16.0'
  s.add_development_dependency 'sqlite3', '~> 1.3.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'braintree'
end
