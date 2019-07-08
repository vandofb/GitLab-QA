module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against gitlab.com
          #
          class Production < DeploymentBase
            def deployment_component
              Component::Production
            end
          end
        end
      end
    end
  end
end
