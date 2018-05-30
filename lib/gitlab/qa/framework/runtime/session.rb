require 'rspec/core'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium-webdriver'

module Gitlab
  module QA
    module Framework
      module Runtime
        class Session
          include Capybara::DSL

          def initialize(instance, page = nil)
            @session_address = Address.new(instance, page)
          end

          def url
            @session_address.address
          end

          def perform(&block)
            visit(url)

            yield if block_given?
          rescue StandardError
            raise if block.nil?

            # RSpec examples will take care of screenshots on their own
            #
            unless block.binding.receiver.is_a?(RSpec::Core::ExampleGroup)
              screenshot_and_save_page
            end

            raise
          ensure
            clear! if block_given?
          end

          ##
          # Selenium allows to reset session cookies for current domain only.
          #
          # See gitlab-org/gitlab-qa#102
          #
          def clear!
            visit(url)
            reset_session!
          end
        end
      end
    end
  end
end
