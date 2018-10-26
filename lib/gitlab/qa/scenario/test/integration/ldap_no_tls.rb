require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class LDAPNoTLS < LDAP
            def initialize
              @gitlab_name = 'gitlab-ldap'
              @spec_suite = 'Test::Integration::LDAPNoTLS'
              @tls = false
            end

            def configure(gitlab, ldap)
              gitlab.omnibus_config = <<~OMNIBUS
                    gitlab_rails['ldap_enabled'] = true;
                    gitlab_rails['ldap_servers'] = #{ldap.to_config};
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
