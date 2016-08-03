module Page
  module Main
    class Projects < Page::Base
      def go_to_new_project
        click_on 'New Project'
      end
    end
  end
end
