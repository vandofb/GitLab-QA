module QA
  module Scenario
    module Test
      module Instance
        ##
        # Run test suite against any GitLab instance,
        # including staging and on-premises installation.
        #
        class Any < Scenario::Template
          def perform(address, tag)
            Spec::Image.perform do |specs|
              specs.test(address, tag)
            end
          end
        end
      end
    end
  end
end
