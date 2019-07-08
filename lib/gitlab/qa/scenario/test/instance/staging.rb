module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against staging.gitlab.com
          #
          class Staging < DeploymentBase
            def deployment_component
              Component::Staging
            end
          end
        end
      end
    end
  end
end
