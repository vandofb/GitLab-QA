$LOAD_PATH.unshift(File.expand_path(__dir__)).uniq!

module Gitlab
  module QA
    module Component
      autoload :Gitlab, 'qa/component/gitlab'
      autoload :LDAP, 'qa/component/ldap'
      autoload :Specs, 'qa/component/specs'
      autoload :Staging, 'qa/component/staging'
    end

    module Runtime
      autoload :Env, 'qa/runtime/env'
      autoload :Scenario, 'qa/runtime/scenario'
    end

    module Scenario
      module Test
        autoload :Template, 'qa/scenario/test/template'

        module Instance
          autoload :Any, 'qa/scenario/test/instance/any'
          autoload :Image, 'qa/scenario/test/instance/image'
          autoload :Staging, 'qa/scenario/test/instance/staging'
        end

        module Omnibus
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

    autoload :Release, 'qa/release'
  end
end

require 'qa/framework'
