module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Geo < Scenario::Template
            # rubocop:disable Metrics/MethodLength
            def perform(release)
              release = Release.new(release)

              unless release.edition == :ee
                raise ArgumentError, 'Geo is EE only!'
              end

              Component::Gitlab.perform do |primary|
                primary.release = release
                configure_primary(primary)

                primary.instance do
                  Component::Gitlab.perform do |secondary|
                    secondary.release = release
                    configure_secondary(secondary)

                    secondary.instance do
                      # shellout to instance specs
                    end
                  end
                end
              end
            end

            private

            def configure_primary(node)
              node.add_omnibus_config("geo_primary_role['enable'] = true")
              node.add_omnibus_config("postgresql['listen_address'] = '0.0.0.0'")
              node.add_omnibus_config("postgresql['trust_auth_cidr_addresses'] = ['0.0.0.0/0','0.0.0.0/0']")
              node.add_omnibus_config("postgresql['md5_auth_cidr_addresses'] = ['0.0.0.0/0']")
              node.add_omnibus_config("postgresql['max_replication_slots'] = 1")
              node.add_omnibus_config("gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc'")
            end

            def configure_secondary(node)
              node.add_omnibus_config("geo_secondary_role['enable'] = true")
              node.add_omnibus_config("gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc'")
            end
          end
        end
      end
    end
  end
end
