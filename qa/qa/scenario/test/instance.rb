module QA
  module Scenario
    module Test
      ##
      # Run test suite against any GitLab instance,
      # including staging and on-premises installation.
      #
      class Instance < Scenario::Template
        def perform(address, *files)
          Spec::Config.perform do |specs|
            specs.address = address
          end

          Spec::Run.perform do |specs|
            specs.rspec(files.any? ? files : 'qa/spec/features')
          end
        end
      end
    end
  end
end
