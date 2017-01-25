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
                Spec::Config.perform do |specs|
                  specs.address = address
                end

                Spec::Run.act { test_instance(:ce) }
              end
            end
          end
        end
      end
    end
  end
end
