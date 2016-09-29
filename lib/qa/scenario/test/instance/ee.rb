module QA
  module Scenario
    module Test
      module Instance
        class EE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength
          # rubocop:disable Metrics/AbcSize

          def perform(*)
            Docker::Network.act do
              create('test') unless exists?('test')
            end

            Docker::Gitlab.act(@tag, @volumes) do |tag, volumes|
              with_name('gitlab-qa-ee')
              with_image('gitlab/gitlab-ee')
              with_image_tag(tag)
              with_volumes(volumes)
              within_network('test')

              instance do |url|
                Spec::Config.act(url) do |address|
                  with_address(address)
                  configure!
                end

                Scenario::License::Add.perform
                Spec::Run.act { instance(:ee) }
              end
            end
          end
        end
      end
    end
  end
end
