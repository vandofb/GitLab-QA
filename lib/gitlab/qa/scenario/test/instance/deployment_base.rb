module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Base class to be used to define deployment environment scenarios
          #
          class DeploymentBase < Scenario::Template
            def perform(release_name = nil, *rspec_args)
              Runtime::Env.require_no_license!

              release_name ||= '--'

              case release_name
              when '--'
                rspec_args.unshift('--')
                release = deployment_component.release
              else
                release = Release.new(release_name)
              end

              if release.dev_gitlab_org?
                Docker::Command.execute(
                  [
                    'login',
                    '--username gitlab-qa-bot',
                    %(--password "#{Runtime::Env.dev_access_token_variable}"),
                    Release::DEV_REGISTRY
                  ]
                )
              end

              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance::All'
                specs.release = release
                specs.args = [deployment_component::ADDRESS, *rspec_args]
              end
            end

            def deployment_component
              raise NotImplementedError, 'Please define the Component for the deployment environment associated with this scenario.'
            end
          end
        end
      end
    end
  end
end
