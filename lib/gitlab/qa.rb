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
          autoload :Image, 'qa/scenario/test/instance/image'
          autoload :Any, 'qa/scenario/test/instance/any'
        end

        module Omnibus
          autoload :Image, 'qa/scenario/test/omnibus/image'
          autoload :Upgrade, 'qa/scenario/test/omnibus/upgrade'
        end

        module Integration
          autoload :Mattermost, 'qa/scenario/test/integration/mattermost'
        end

        module Sanity
          autoload :Version, 'qa/scenario/test/sanity/version'
        end
      end
    end

    module Component
      autoload :Gitlab, 'qa/component/gitlab'
      autoload :Specs, 'qa/component/specs'
    end

    module Docker
      autoload :Engine, 'qa/docker/engine'
      autoload :Command, 'qa/docker/command'
      autoload :Shellout, 'qa/docker/shellout'
    end
  end
end
