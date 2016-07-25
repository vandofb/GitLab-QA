require 'capybara/rspec'
require 'capybara-webkit'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`.
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end


Capybara.configure do |config|
  config.app_host = ENV['GITLAB_HOST']
  config.default_driver = :webkit
end

Capybara::Webkit.configure do |config|
  config.allow_url(ENV['GITLAB_HOST'])
end
