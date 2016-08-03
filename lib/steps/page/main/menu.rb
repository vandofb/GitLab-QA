module Page
  module Main
    class Menu < Page::Base
      def initialize
        find('.side-nav-toggle').click
      end

      def go_to_groups
        within_menu { click_link 'Groups' }
      end

      def go_to_projects
        within_menu { click_link 'Projects' }
      end

      private

      def within_menu
        page.within('ul.nav-sidebar') do
          yield
        end
      end
    end
  end
end
