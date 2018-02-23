module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against staging.gitlab.com
          #
          class Staging < Scenario::Template
            def perform(*)
              Runtime::Env.require_no_license!

              release = Component::Staging.release

              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance'
                specs.release = release
                specs.args = [Component::Staging::ADDRESS]
              end
            end
          end
        end
      end
    end
  end
end
