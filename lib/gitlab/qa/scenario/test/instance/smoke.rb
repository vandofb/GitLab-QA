module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run smoke test suite against any GitLab instance,
          # including staging and on-premises installation.
          #
          class Smoke < Scenario::Template
            def perform(edition_and_tag, address, *rspec_args)
              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance::Smoke'
                specs.release = Release.new(edition_and_tag)
                specs.args = [address, *rspec_args]
              end
            end
          end
        end
      end
    end
  end
end
