$LOAD_PATH << File.expand_path(__dir__)

module Gitlab
  module QA
    autoload :Release, 'qa/release'

    module Runtime
      autoload :Env, 'qa/runtime/env'
    end

    module Scenario
      autoload :Actable, 'qa/scenario/actable'
      autoload :Template, 'qa/scenario/template'

      module Test
        module Instance
          autoload :Any, 'qa/scenario/test/instance/any'
          autoload :Image, 'qa/scenario/test/instance/image'
          autoload :RelativeUrl, 'qa/scenario/test/instance/relative_url'
          autoload :Staging, 'qa/scenario/test/instance/staging'
          autoload :Smoke, 'qa/scenario/test/instance/smoke'
        end

        module Omnibus
          autoload :Image, 'qa/scenario/test/omnibus/image'
          autoload :Update, 'qa/scenario/test/omnibus/update'
          autoload :Upgrade, 'qa/scenario/test/omnibus/upgrade'
        end

        module Integration
          autoload :Geo, 'qa/scenario/test/integration/geo'
          autoload :LDAPNoTLS, 'qa/scenario/test/integration/ldap_no_tls'
          autoload :SAML, 'qa/scenario/test/integration/saml'
          autoload :GroupSAML, 'qa/scenario/test/integration/group_saml'
          autoload :InstanceSAML, 'qa/scenario/test/integration/instance_saml'
          autoload :Mattermost, 'qa/scenario/test/integration/mattermost'
          autoload :Kubernetes, 'qa/scenario/test/integration/kubernetes'
          autoload :ObjectStorage, 'qa/scenario/test/integration/object_storage'
        end

        module Sanity
          autoload :Version, 'qa/scenario/test/sanity/version'
        end
      end
    end

    module Component
      autoload :Gitlab, 'qa/component/gitlab'
      autoload :InternetTunnel, 'qa/component/internet_tunnel'
      autoload :LDAP, 'qa/component/ldap'
      autoload :SAML, 'qa/component/saml'
      autoload :Specs, 'qa/component/specs'
      autoload :Staging, 'qa/component/staging'
      autoload :Minio, 'qa/component/minio'
    end

    module Docker
      autoload :Command, 'qa/docker/command'
      autoload :Engine, 'qa/docker/engine'
      autoload :Shellout, 'qa/docker/shellout'
      autoload :Volumes, 'qa/docker/volumes'
    end
  end
end
