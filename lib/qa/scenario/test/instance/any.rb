module QA
  module Scenario
    module Test
      module Instance
        ##
        # Run test suite against any GitLab instance,
        # including staging and on-premises installation.
        #
        class Any < Scenario::Template
          def perform(address, tag, *files)
            Spec::Config.perform do |specs|
              specs.address = address
            end

            Spec::Run.perform do |specs|
              specs.rspec(tag.downcase, files)
            end
          end
        end
      end
    end
  end
end
