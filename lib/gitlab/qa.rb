$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module QA
  module Scenario
    autoload :Actable, 'qa/scenario/actable'
    autoload :Template, 'qa/scenario/template'

    module Test
      module Gitlab
        autoload :Image, 'qa/scenario/test/gitlab/image'
        autoload :Any, 'qa/scenario/test/gitlab/any'
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
