module Gitlab
  module QA
    autoload :Release, 'gitlab/qa/release'
    autoload :Runner, 'gitlab/qa/runner'

    module Runtime
      autoload :Env, 'gitlab/qa/runtime/env'
    end

    module Scenario
      autoload :Actable, 'gitlab/qa/scenario/actable'
      autoload :Template, 'gitlab/qa/scenario/template'

      module Test
        module Instance
          autoload :Any, 'gitlab/qa/scenario/test/instance/any'
          autoload :DeploymentBase, 'gitlab/qa/scenario/test/instance/deployment_base'
          autoload :Image, 'gitlab/qa/scenario/test/instance/image'
          autoload :RelativeUrl, 'gitlab/qa/scenario/test/instance/relative_url'
          autoload :Staging, 'gitlab/qa/scenario/test/instance/staging'
          autoload :Production, 'gitlab/qa/scenario/test/instance/production'
          autoload :Smoke, 'gitlab/qa/scenario/test/instance/smoke'
          autoload :Preprod, 'gitlab/qa/scenario/test/instance/preprod'
          autoload :Onprem, 'gitlab/qa/scenario/test/instance/onprem'
        end

        module Omnibus
          autoload :Image, 'gitlab/qa/scenario/test/omnibus/image'
          autoload :Update, 'gitlab/qa/scenario/test/omnibus/update'
          autoload :Upgrade, 'gitlab/qa/scenario/test/omnibus/upgrade'
        end

        module Integration
          autoload :Geo, 'gitlab/qa/scenario/test/integration/geo'
          autoload :LDAP, 'gitlab/qa/scenario/test/integration/ldap'
          autoload :LDAPNoTLS, 'gitlab/qa/scenario/test/integration/ldap_no_tls'
          autoload :LDAPTLS, 'gitlab/qa/scenario/test/integration/ldap_tls'
          autoload :SAML, 'gitlab/qa/scenario/test/integration/saml'
          autoload :GroupSAML, 'gitlab/qa/scenario/test/integration/group_saml'
          autoload :InstanceSAML, 'gitlab/qa/scenario/test/integration/instance_saml'
          autoload :Mattermost, 'gitlab/qa/scenario/test/integration/mattermost'
          autoload :Kubernetes, 'gitlab/qa/scenario/test/integration/kubernetes'
          autoload :ObjectStorage, 'gitlab/qa/scenario/test/integration/object_storage'
          autoload :OAuth, 'gitlab/qa/scenario/test/integration/oauth'
          autoload :Elasticsearch, 'gitlab/qa/scenario/test/integration/elasticsearch'
        end

        module Sanity
          autoload :Version, 'gitlab/qa/scenario/test/sanity/version'
        end
      end
    end

    module Component
      autoload :Gitlab, 'gitlab/qa/component/gitlab'
      autoload :InternetTunnel, 'gitlab/qa/component/internet_tunnel'
      autoload :LDAP, 'gitlab/qa/component/ldap'
      autoload :SAML, 'gitlab/qa/component/saml'
      autoload :Specs, 'gitlab/qa/component/specs'
      autoload :Staging, 'gitlab/qa/component/staging'
      autoload :Production, 'gitlab/qa/component/production'
      autoload :Minio, 'gitlab/qa/component/minio'
      autoload :Preprod, 'gitlab/qa/component/preprod'
      autoload :Elasticsearch, 'gitlab/qa/component/elasticsearch'
      autoload :Onprem, 'gitlab/qa/component/onprem'
    end

    module Docker
      autoload :Command, 'gitlab/qa/docker/command'
      autoload :Engine, 'gitlab/qa/docker/engine'
      autoload :Shellout, 'gitlab/qa/docker/shellout'
      autoload :Volumes, 'gitlab/qa/docker/volumes'
    end
  end
end
