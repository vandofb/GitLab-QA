module QA
  module Scenario
    module Test
      module Instance
        class CE < Instance::Gitlab
          # rubocop:disable Metrics/MethodLength
          # rubocop:disable Metrics/AbcSize

          def perform(*)
            Docker::Network.act do
              create('test') unless exists?('test')
            end

            Docker::Gitlab.act(@tag, @volumes) do |tag, volumes|
              with_name('gitlab-qa-ce')
              with_image('gitlab/gitlab-ce')
              with_image_tag(tag)
              with_volumes(volumes)
              within_network('test')

              instance do |url|
                Spec::Config.act(url) do |address|
                  with_address(address)
                  configure!
                end

                Spec::Run.act { instance(:ce) }
              end
            end
          end
        end
      end
    end
  end
end
