module QA
  module Scenario
    module Test
      module Instance
        class EE < Scenario::Template
          # rubocop:disable Metrics/MethodLength
          # rubocop:disable Metrics/AbcSize

          def perform
            Docker::Network.act do
              create('test') unless exists?('test')
            end

            Docker::Gitlab.act do
              with_name('gitlab-qa-ee')
              with_image('gitlab/gitlab-ee')
              with_image_tag('nightly')
              within_network('test')

              instance do |url|
                Spec::Config.act(url) do |address|
                  with_url(address)
                  configure!
                end

                Scenario::License::Add.perform
                Spec::Run.act { suite(:ee) }
              end
            end
          end
        end
      end
    end
  end
end
