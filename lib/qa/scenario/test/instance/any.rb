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
            Spec::Config.act(address) do |address|
              with_address(address)
              configure!
            end

            Spec::Run.act(tag, files) do |tag, files|
              rspec(tag.downcase, files)
            end
          end
        end
      end
    end
  end
end
