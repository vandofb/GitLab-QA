$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module QA
  module Test
    autoload :User, 'qa/test/user'
    autoload :Namespace, 'qa/test/namespace'
  end

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

    module Gitlab
      module Project
        autoload :Create, 'qa/scenario/gitlab/project/create'
      end

      module License
        autoload :Add, 'qa/scenario/gitlab/license/add'
      end
    end
  end

  module Spec
    autoload :Base, 'qa/spec/base'
    autoload :Config, 'qa/spec/config'
    autoload :Run, 'qa/spec/run'
  end

  module Page
    autoload :Base, 'qa/page/base'

    module Main
      autoload :Entry, 'qa/page/main/entry'
      autoload :Menu, 'qa/page/main/menu'
      autoload :Groups, 'qa/page/main/groups'
      autoload :Projects, 'qa/page/main/projects'
    end

    module Project
      autoload :New, 'qa/page/project/new'
      autoload :Show, 'qa/page/project/show'
    end

    module Admin
      autoload :Menu, 'qa/page/admin/menu'
      autoload :License, 'qa/page/admin/license'
    end
  end

  module Git
    autoload :Repository, 'qa/git/repository'
  end

  module Docker
    autoload :Engine, 'qa/docker/engine'
    autoload :Command, 'qa/docker/command'
    autoload :Gitlab, 'qa/docker/gitlab'
  end
end
