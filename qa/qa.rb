$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module QA
  module Test
    autoload :User, 'qa/test/user'
    autoload :Namespace, 'qa/test/namespace'
  end

  module Scenario
    autoload :Actable, 'qa/scenario/actable'
    autoload :Template, 'qa/scenario/template'

    module Gitlab
      module Project
        autoload :Create, 'qa/scenario/gitlab/project/create'
      end

      module License
        autoload :Add, 'qa/scenario/gitlab/license/add'
      end
    end
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

  module Spec
    autoload :Base, 'qa/spec/base'
    autoload :Config, 'qa/spec/config'
    autoload :Run, 'qa/spec/run'
  end
end
