$LOAD_PATH << './'

module QA
  module Test
    autoload :User, 'lib/qa/test/user'
    autoload :Namespace, 'lib/qa/test/namespace'
  end

  module Scenario
    autoload :Actable, 'lib/qa/scenario/actable'
    autoload :Template, 'lib/qa/scenario/template'

    module Test
      module Instance
        autoload :CE, 'lib/qa/scenario/test/instance/ce'
        autoload :EE, 'lib/qa/scenario/test/instance/ee'
      end
    end

    module Project
      autoload :Create, 'lib/qa/scenario/project/create'
    end

    module License
      autoload :Add, 'lib/qa/scenario/license/add'
    end
  end

  module Spec
    autoload :Base, 'lib/qa/spec/base'
    autoload :Config, 'lib/qa/spec/config'
    autoload :Run, 'lib/qa/spec/run'
  end

  module Page
    autoload :Base, 'lib/qa/page/base'

    module Main
      autoload :Entry, 'lib/qa/page/main/entry'
      autoload :Menu, 'lib/qa/page/main/menu'
      autoload :Groups, 'lib/qa/page/main/groups'
      autoload :Projects, 'lib/qa/page/main/projects'
    end

    module Project
      autoload :New, 'lib/qa/page/project/new'
      autoload :Show, 'lib/qa/page/project/show'
    end

    module Admin
      autoload :Menu, 'lib/qa/page/admin/menu'
      autoload :License, 'lib/qa/page/admin/license'
    end
  end

  module Git
    autoload :Repository, 'lib/qa/git/repository'
  end

  module Docker
    autoload :Base, 'lib/qa/docker/base'
    autoload :Network, 'lib/qa/docker/network'
    autoload :Gitlab, 'lib/qa/docker/gitlab'
  end
end
