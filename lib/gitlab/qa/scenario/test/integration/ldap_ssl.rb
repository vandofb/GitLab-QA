require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class LDAPSSL < Scenario::Template
            # rubocop:disable Metrics/AbcSize
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.name = 'gitlab'
                gitlab.network = 'test'
                gitlab.tls = true

                Component::LDAP.perform do |ldap|
                  ldap.tls = true
                  ldap.network = 'test'
                  ldap.set_gitlab_credentials

                  gitlab.omnibus_config = <<~OMNIBUS
                    gitlab_rails['ldap_enabled'] = true;
                    gitlab_rails['ldap_servers'] = #{ldap.to_config};
                    letsencrypt['enable'] = false;
                    external_url '#{gitlab.address}';
                  OMNIBUS

                  ldap.instance do
                    gitlab.instance do
                      puts 'Running LDAP SSL specs!'

                      Component::Specs.perform do |specs|
                        specs.suite = 'Test::Integration::LDAP'
                        specs.release = gitlab.release
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
