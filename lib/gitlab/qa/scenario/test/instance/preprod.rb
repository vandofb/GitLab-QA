module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against pre.gitlab.com
          #
          class Preprod < DeploymentBase
            def deployment_component
              Component::Preprod
            end
          end
        end
      end
    end
  end
end
