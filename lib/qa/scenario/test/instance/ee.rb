module QA
  module Scenario
    module Test
      module Instance
        class EE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength

          def perform(*)
            Docker::Gitlab.perform do |gitlab|
              gitlab.name = 'gitlab-qa-ee'
              gitlab.image = 'gitlab/gitlab-ee'
              gitlab.tag = @tag
              gitlab.volumes = @volumes
              gitlab.network = 'test'

              gitlab.instance do |address|
                Spec::Config.perform do |specs|
                  specs.address = address
                end

                Scenario::Gitlab::License::Add.perform
                Spec::Run.act { test_instance(:ee) }
              end
            end
          end
        end
      end
    end
  end
end
