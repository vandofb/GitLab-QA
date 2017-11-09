module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Mattermost < Scenario::Template
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'

                mattermost_hostname = "mattermost.#{gitlab.network}"
                mattermost_external_url = "http://#{mattermost_hostname}"

                gitlab.network_aliases = [mattermost_hostname]
                gitlab.add_omnibus_config(
                  "mattermost_external_url '#{mattermost_external_url}'")

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::Mattermost'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, mattermost_external_url]
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
