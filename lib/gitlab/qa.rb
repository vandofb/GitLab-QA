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
          autoload :Staging, 'qa/scenario/test/instance/staging'
        end

        module Omnibus
          autoload :CustomUpdate, 'qa/scenario/test/omnibus/custom_update'
          autoload :Image, 'qa/scenario/test/omnibus/image'
          autoload :Update, 'qa/scenario/test/omnibus/update'
          autoload :Upgrade, 'qa/scenario/test/omnibus/upgrade'
        end

        module Integration
          autoload :Geo, 'qa/scenario/test/integration/geo'
          autoload :LDAP, 'qa/scenario/test/integration/ldap'
          autoload :Mattermost, 'qa/scenario/test/integration/mattermost'
        end

        module Sanity
          autoload :Version, 'qa/scenario/test/sanity/version'
        end
      end
    end

    module Component
      autoload :Gitlab, 'qa/component/gitlab'
      autoload :LDAP, 'qa/component/ldap'
      autoload :Specs, 'qa/component/specs'
      autoload :Staging, 'qa/component/staging'
    end

    module Docker
      autoload :Command, 'qa/docker/command'
      autoload :Engine, 'qa/docker/engine'
      autoload :Shellout, 'qa/docker/shellout'
      autoload :Volumes, 'qa/docker/volumes'
    end
  end
end
