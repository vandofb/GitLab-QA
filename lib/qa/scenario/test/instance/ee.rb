module QA
  module Scenario
    module Test
      module Instance
        class EE < Instance::Gitlab
          def perform(*)
            Docker::Gitlab.perform do |gitlab|
              gitlab.name = 'gitlab-qa-ee'
              gitlab.image = 'gitlab/gitlab-ee'
              gitlab.tag = @tag
              gitlab.volumes = @volumes
              gitlab.network = 'test'

              gitlab.instance do |address|
                Spec::Image.act { test(address, :ee) }
              end
            end
          end
        end
      end
    end
  end
end
