module Run
  autoload :Namespace, 'lib/run/namespace'
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
  end
end

module Scenario
  autoload :Template, 'lib/scenario/template'

  module Project
    autoload :Create, 'lib/scenario/project/create'
  end
end
