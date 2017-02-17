$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module QA
  module Scenario
    autoload :Actable, 'qa/scenario/actable'
    autoload :Template, 'qa/scenario/template'

    module Test
      module Instance
        autoload :Gitlab, 'qa/scenario/test/instance/gitlab'
        autoload :CE, 'qa/scenario/test/instance/ce'
        autoload :EE, 'qa/scenario/test/instance/ee'
        autoload :Any, 'qa/scenario/test/instance/any'
      end

      module Internal
        autoload :Unit, 'qa/scenario/test/internal/unit'
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
