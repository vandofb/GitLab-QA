require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class GroupSAML < SAML
            def initialize
              @gitlab_name = 'gitlab-group-saml'
              @spec_suite = 'QA::EE::Scenario::Test::Integration::GroupSAML'
            end

            def before_perform(release)
              raise ArgumentError, 'Group SAML is EE only feature!' unless release.ee?
            end

            def configure(gitlab, saml)
              saml.set_entity_id("#{gitlab.address}/groups/#{saml.group_name}")
              saml.set_assertion_consumer_service("#{gitlab.address}/groups/#{saml.group_name}/-/saml/callback")
              saml.set_sandbox_name(saml.group_name)
              saml.set_simple_saml_hostname
              saml.set_accept_insecure_certs

              gitlab.omnibus_config = <<~OMNIBUS
                gitlab_rails['omniauth_enabled'] = true;
                gitlab_rails['omniauth_providers'] = [{ name: 'group_saml' }];
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
