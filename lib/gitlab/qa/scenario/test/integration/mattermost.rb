module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Mattermost < Scenario::Template
            # rubocop:disable Metrics/MethodLength
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'

                mattermost_hostname = "mattermost.#{gitlab.network}"
                mattermost_external_url = "http://#{mattermost_hostname}"
                gitlab.omnibus_config =
                  "mattermost_external_url '#{mattermost_external_url}'"
                gitlab.network_aliases = [mattermost_hostname]

                gitlab.instance do
                  Component::Specs.perform do |instance|
                    instance.test(
                      gitlab: gitlab,
                      suite: 'Test::Integration::Mattermost',
                      extra_args: [mattermost_external_url]
                    )
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
