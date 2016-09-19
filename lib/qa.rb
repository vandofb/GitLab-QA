$LOAD_PATH << './'

module QA
  module Run
    autoload :User, 'lib/qa/run/user'
    autoload :Namespace, 'lib/qa/run/namespace'
  end

  module Scenario
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

  module RSpec
    autoload :Base, 'lib/qa/steps/rspec/base'
    autoload :Config, 'lib/qa/steps/rspec/config'
    autoload :Run, 'lib/qa/steps/rspec/run'
  end

  module Page
    autoload :Base, 'lib/qa/steps/page/base'

    module Main
      autoload :Entry, 'lib/qa/steps/page/main/entry'
      autoload :Menu, 'lib/qa/steps/page/main/menu'
      autoload :Groups, 'lib/qa/steps/page/main/groups'
      autoload :Projects, 'lib/qa/steps/page/main/projects'
    end

    module Project
      autoload :New, 'lib/qa/steps/page/project/new'
      autoload :Show, 'lib/qa/steps/page/project/show'
    end

    module Admin
      autoload :Menu, 'lib/qa/steps/page/admin/menu'
      autoload :License, 'lib/qa/steps/page/admin/license'
    end
  end

  module Git
    autoload :Repository, 'lib/qa/steps/git/repository'
  end
end
