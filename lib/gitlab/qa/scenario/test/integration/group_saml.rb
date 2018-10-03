require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class GroupSAML < Scenario::Template
            # rubocop:disable Metrics/AbcSize
            def perform(release)
              release = Release.new(release)

              raise ArgumentError, 'Group SAML is EE only feature!' unless release.ee?

              Component::Gitlab.perform do |gitlab|
                gitlab.release = release.edition
                gitlab.name = 'gitlab-saml'
                gitlab.network = 'test'

                Component::SAML.perform do |saml|
                  saml.network = 'test'
                  saml.set_entity_id("#{gitlab.address}/groups/#{saml.group_name}")
                  saml.set_assertion_consumer_service("#{gitlab.address}/groups/#{saml.group_name}/-/saml/callback")
                  saml.set_sandbox_name(saml.group_name)
                  saml.set_simple_saml_hostname
                  saml.set_accept_insecure_certs

                  gitlab.omnibus_config = <<~OMNIBUS
                    gitlab_rails['omniauth_enabled'] = true;
                    gitlab_rails['omniauth_providers'] = [{ name: 'group_saml' }];
                  OMNIBUS

                  saml.instance do
                    gitlab.instance do
                      puts 'Running SAML specs!'

                      Component::Specs.perform do |specs|
                        specs.suite = 'QA::EE::Scenario::Test::Integration::GroupSAML'
                        specs.release = release
                        specs.network = gitlab.network
                        specs.args = [gitlab.address]
                      end
                    end
                  end
                end
              end
            end
            # rubocop:enable Metrics/AbcSize
          end
        end
      end
    end
  end
end
