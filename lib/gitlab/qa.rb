$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Gitlab
  module QA
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
      end
    end

    module Docker
      autoload :Engine, 'qa/docker/engine'
      autoload :Command, 'qa/docker/command'
      autoload :Gitlab, 'qa/docker/gitlab'
      autoload :Specs, 'qa/docker/specs'
    end
  end
end
