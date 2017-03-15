module QA
  module Scenario
    module Test
      module Instance
        class EE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength

          def perform(*)
            Docker::Gitlab.perform do |gitlab|
              gitlab.release = :ee
              gitlab.name = 'gitlab-qa-ee'
              gitlab.image = 'gitlab/gitlab-ee'
              gitlab.tag = @tag
              gitlab.volumes = @volumes
              gitlab.network = 'test'

              gitlab.instance do
                Docker::Specs.perform do |instance|
                  instance.env = 'EE_LICENSE'
                  instance.test(gitlab)
                end
              end
            end
          end
        end
      end
    end
  end
end
