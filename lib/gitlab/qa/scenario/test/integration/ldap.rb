require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class LDAP
            include Template

            # rubocop:disable Metrics/AbcSize
            def perform(options, release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.name = 'gitlab-ldap'
                gitlab.network = 'test'

                Component::LDAP.perform do |ldap|
                  ldap.enable_tls(false)
                  ldap.network = 'test'
                  ldap.set_gitlab_credentials

                  gitlab.omnibus_config = <<~OMNIBUS
                    gitlab_rails['ldap_enabled'] = true;
                    gitlab_rails['ldap_servers'] = #{ldap.to_config};
                  OMNIBUS

                  ldap.instance do
                    gitlab.instance do
                      puts 'Running LDAP specs!'

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
