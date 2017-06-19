module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Image < Scenario::Template
            # rubocop:disable Style/Semicolon
            # rubocop:disable Metrics/MethodLength
            def perform(release)
              Docker::Gitlab.perform do |instance|
                instance.release = release
                instance.name = "gitlab-qa-#{instance.release.edition}"
                instance.image = instance.release.image
                instance.tag = instance.release.tag
                instance.network = 'bridge'

                instance.act do
                  prepare; start; reconfigure
                  restart; wait; teardown
                end
              end
            end
          end
        end
      end
    end
  end
end
