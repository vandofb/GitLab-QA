module Run
  autoload :User, 'lib/run/user'
  autoload :Namespace, 'lib/run/namespace'
end

module Scenario
  autoload :Template, 'lib/scenario/template'

  module Project
    autoload :Create, 'lib/scenario/project/create'
  end

  module Instance
    module License
      autoload :Add, 'lib/scenario/instance/license/add'
    end
  end
end

module Page
  autoload :Base, 'lib/steps/page/base'

  module Main
    autoload :Entry, 'lib/steps/page/main/entry'
    autoload :Menu, 'lib/steps/page/main/menu'
    autoload :Groups, 'lib/steps/page/main/groups'
    autoload :Projects, 'lib/steps/page/main/projects'
  end

  module Project
    autoload :New, 'lib/steps/page/project/new'
    autoload :Show, 'lib/steps/page/project/show'
  end

  module Admin
    autoload :Menu, 'lib/steps/page/admin/menu'
    autoload :License, 'lib/steps/page/admin/license'
  end
end

module Git
  autoload :Repository, 'lib/steps/git/repository'
end
