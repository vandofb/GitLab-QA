module Page
  autoload :Base, 'lib/steps/page/base'

  ##
  # Top-level pages
  #
  module Main
    autoload :Entry, 'lib/steps/page/main/entry'
    autoload :Menu, 'lib/steps/page/main/menu'
    autoload :Groups, 'lib/steps/page/main/groups'
    autoload :Projects, 'lib/steps/page/main/projects'
  end

  ##
  # Projet-specific pages
  #
  module Project
    autoload :New, 'lib/steps/page/project/new'
  end
end
