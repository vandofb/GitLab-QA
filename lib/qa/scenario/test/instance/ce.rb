module QA
  module Scenario
    module Test
      module Instance
        class CE < Scenario::Template
          # rubocop:disable Metrics/MethodLength

          def perform
            Docker::Network.act do
              create('test') unless exists?('test')
            end

            Docker::Gitlab.act do
              with_name('gitlab-qa-ce')
              with_image('gitlab/gitlab-ce')
              with_image_tag('nightly')
              within_network('test')

              instance do |url|
                Spec::Config.act(url) do |address|
                  with_url(address)
                  configure!
                end

                Spec::Run.act { suite(:ce) }
              end
            end
          end
        end
      end
    end
  end
end
