module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against any GitLab instance,
          # including staging and on-premises installation.
          #
          class Any < Scenario::Template
            def perform(release, tag, address)
              Docker::Specs.perform do |instance|
                instance.test_address(release, tag, address)
              end
            end
          end
        end
      end
    end
  end
end
