$LOAD_PATH << './'

require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara-screenshot/rspec'
require 'lib/qa'

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

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  config.before(:all) do
    page.current_window.resize_to(1200, 1200)
  end

  config.before(:suite) do
    # Add valid license when running tests for enterprise edition
    if config.filter_manager.inclusions[:ee]
      Scenario::Instance::License::Add.perform
    end
  end
end

Capybara.configure do |config|
  config.app_host = ENV['GITLAB_URL']
  config.default_driver = :webkit
  config.javascript_driver = :webkit
  config.default_max_wait_time = 4

  # https://github.com/mattheworiordan/capybara-screenshot/issues/164
  config.save_path = 'tmp'
end

Capybara::Webkit.configure do |config|
  config.allow_url(ENV['GITLAB_URL'])
  config.block_unknown_urls
end
