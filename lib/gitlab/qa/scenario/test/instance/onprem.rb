module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against pre.gitlab.com
          #
          class Onprem < Scenario::Template
            def perform(*rspec_args)
              Runtime::Env.require_no_license!

              release = Component::Onprem.release

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
                specs.args = [Component::Onprem::ADDRESS, *rspec_args]
              end
            end
          end
        end
      end
    end
  end
end
