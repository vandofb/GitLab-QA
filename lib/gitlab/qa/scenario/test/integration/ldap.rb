require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class LDAP < Scenario::Template
            attr_reader :gitlab_name, :spec_suite, :tls

            def configure(gitlab, ldap)
              raise NotImplementedError
            end

            # rubocop:disable Metrics/AbcSize
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.name = gitlab_name
                gitlab.network = 'test'
                gitlab.tls = tls

                Component::LDAP.perform do |ldap|
                  ldap.name = 'ldap-server'
                  ldap.network = 'test'
                  ldap.set_gitlab_credentials
                  ldap.tls = tls

                  configure(gitlab, ldap)

                  ldap.instance do
                    gitlab.instance do
                      puts "Running #{spec_suite} specs!"

                      Component::Specs.perform do |specs|
                        specs.suite = spec_suite
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
