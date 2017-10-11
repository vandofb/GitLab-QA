module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Mattermost < Scenario::Template
            # rubocop:disable Metrics/MethodLength
            def perform(release)
              Docker::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'

                mattermost_hostname = "mattermost.#{gitlab.network}"
                gitlab.omnibus_config =
                  "mattermost_external_url 'http://#{mattermost_hostname}'"
                gitlab.network_aliases = [mattermost_hostname]

                gitlab.instance do
                  Docker::Specs.perform do |instance|
                    instance.test(gitlab: gitlab)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
