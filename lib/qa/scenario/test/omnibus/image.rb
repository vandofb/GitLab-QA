module QA
  module Scenario
    module Test
      module Omnibus
        class Image < Scenario::Template
          # rubocop:disable Style/Semicolon

          def perform(version)
            Docker::Gitlab.perform do |instance|
              instance.name = "gitlab-qa-#{version.downcase}"
              instance.image = "gitlab/gitlab-#{version.downcase}"
              instance.tag = 'nightly'
              instance.network = 'bridge'

              instance.act { prepare; start; reconfigure; teardown }
            end
          end
        end
      end
    end
  end
end
