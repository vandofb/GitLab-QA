module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against onprem.testbed.gitlab.net
          #
          class Onprem < DeploymentBase
            def deployment_component
              Component::Onprem
            end
          end
        end
      end
    end
  end
end
