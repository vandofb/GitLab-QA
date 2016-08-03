module Page
  autoload :Base, 'steps/page/base'

  ##
  # Top-level pages
  #
  module Main
    autoload :Entry, 'steps/page/main/entry'
    autoload :Menu, 'steps/page/main/menu'
    autoload :Groups, 'steps/page/main/groups'
    autoload :Projects, 'steps/page/main/projects'
  end

  ##
  # Projet-specific pages
  #
  module Project
    autoload :New, 'steps/page/project/new'
  end
end
