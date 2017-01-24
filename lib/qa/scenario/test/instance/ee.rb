module QA
  module Scenario
    module Test
      module Instance
        class EE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength

          def perform(*)
            Docker::Network.act do
              create('test') unless exists?('test')
            end

            Docker::Gitlab.perform do |gitlab|
              gitlab.with_name('gitlab-qa-ee')
              gitlab.with_image('gitlab/gitlab-ee')
              gitlab.with_image_tag(@tag)
              gitlab.with_volumes(@volumes)
              gitlab.within_network('test')

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
