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
              require_no_license!

              release = Component::Staging.release

              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance'
                specs.release = release
                specs.args = [Component::Staging::ADDRESS]
              end
            end

            private

            def require_no_license!
              return unless ENV.include?('EE_LICENSE')

              raise ArgumentError,
                "Cannot set a license on Staging. Unset EE_LICENSE to continue"
            end
          end
        end
      end
    end
  end
end
