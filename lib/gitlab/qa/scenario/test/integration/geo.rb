module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Geo < Scenario::Template
            def perform(release) # rubocop:disable Metrics/MethodLength
              release = Release.new(release)

              unless release.edition == :ee
                raise ArgumentError, 'Geo is EE only!'
              end

              Component::Gitlab.perform do |secondary|
                secondary.release = release
                secondary.network = 'geo'
                secondary.omnibus_config = <<~OMNIBUS
                  geo_secondary_role['enable'] = true;
                  gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc';
                OMNIBUS

                secondary.instance do
                  puts 'Secondary started!'
                end
              end

              # Component::Gitlab.perform do |primary|
              #   primary.release = release
              #   primary.network = 'geo'
              #   primary.omnibus_config = <<~OMNIBUS
              #     geo_primary_role['enable'] = true;
              #     postgresql['listen_address'] = '0.0.0.0';
              #     postgresql['trust_auth_cidr_addresses'] = ['0.0.0.0/0','0.0.0.0/0'];
              #     postgresql['md5_auth_cidr_addresses'] = ['0.0.0.0/0'];
              #     postgresql['max_replication_slots'] = 1;
              #     gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc';
              #   OMNIBUS
              #
              #   primary.instance do
              #     Component::Gitlab.perform do |secondary|
              #       secondary.release = release
              #       secondary.network = 'geo'
              #       secondary.omnibus_config = <<~OMNIBUS
              #         geo_secondary_role['enable'] = true;
              #         gitlab_rails['db_key_base'] = '4dd58204865eb41bca93bd38131d51cc';
              #       OMNIBUS
              #
              #       secondary.instance do
              #         # shellout to instance specs
              #       end
              #     end
              #   end
              # end
            end
          end
        end
      end
    end
  end
end
