module QA
  module Scenario
    module Test
      module Gitlab
        ##
        # Run test suite against any GitLab instance,
        # including staging and on-premises installation.
        #
        class Any < Scenario::Template
          def perform(address)
            Spec::Image.perform do |specs|
              specs.test(address)
            end
          end
        end
      end
    end
  end
end
