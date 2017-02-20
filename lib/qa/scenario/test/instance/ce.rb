module QA
  module Scenario
    module Test
      module Instance
        class CE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength

          def perform(*)
            Docker::Gitlab.perform do |gitlab|
              gitlab.release = :ce
              gitlab.name = 'gitlab-qa-ce'
              gitlab.image = 'gitlab/gitlab-ce'
              gitlab.tag = @tag
              gitlab.volumes = @volumes
              gitlab.network = 'test'

              gitlab.instance do
                Docker::Specs.act(gitlab) do |instance|
                  test(instance)
                end
              end
            end
          end
        end
      end
    end
  end
end
