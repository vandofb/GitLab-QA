module QA
  module Scenario
    module Test
      module Instance
        class CE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength

          def perform(*)
            Docker::Gitlab.perform do |gitlab|
              gitlab.name = 'gitlab-qa-ce'
              gitlab.image = 'gitlab/gitlab-ce'
              gitlab.tag = @tag
              gitlab.volumes = @volumes
              gitlab.network = 'test'

              gitlab.instance do |address|
                Spec::Image.act { test(address, :ce) }
              end
            end
          end
        end
      end
    end
  end
end
