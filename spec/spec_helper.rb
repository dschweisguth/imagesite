require 'bundler'
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.warnings = true

  config.order = :random
  Kernel.srand config.seed

end

require 'capybara/rspec'
Capybara.app = -> env { ['200', {}, [IO.read(env['PATH_INFO'])]] }

require 'simplecov'
SimpleCov.start

require_relative '../lib/image_site/image_site'
