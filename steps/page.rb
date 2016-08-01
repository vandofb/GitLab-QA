module Page
  autoload :Base, 'steps/page/base'

  autoload :Main, 'steps/page/main'
  autoload :Menu, 'steps/page/menu'
  autoload :Groups, 'steps/page/groups'
  autoload :Projects, 'steps/page/projects'

  module Project
    autoload :New, 'steps/page/project/new'
  end
end
