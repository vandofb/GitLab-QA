require 'rspec/core'

module QA
  module Scenario
    module Test
      module Internal
        class Unit < Scenario::Template
          # rubocop:disable Metrics/MethodLength
          # rubocop:disable Metrics/LineLength

          def perform(*args)
            RSpec.configure do |config|
              config.expect_with :rspec do |expectations|
                expectations.include_chain_clauses_in_custom_matcher_descriptions = true
              end

              config.mock_with :rspec do |mocks|
                mocks.verify_partial_doubles = true
              end

              config.order = :random
              Kernel.srand config.seed
              config.formatter = :documentation
              config.color = true
            end

            Spec::Run.perform do |runner|
              runner.rspec(args.any? ? args : %w(spec/))
            end
          end
        end
      end
    end
  end
end
