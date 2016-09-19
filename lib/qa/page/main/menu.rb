module QA
  module Page
    module Main
      class Menu < Page::Base
        def go_to_groups
          within_sidebar_menu { click_link 'Groups' }
        end

        def go_to_projects
          within_sidebar_menu { click_link 'Projects' }
        end

        def go_to_admin_area
          within_top_menu { click_link 'Admin Area' }
        end

        def sign_out
          within_top_menu do
            find('.header-user-dropdown-toggle').click
            click_link('Sign out')
          end
        end

        private

        def within_sidebar_menu
          find('.side-nav-toggle').click

          page.within('ul.nav-sidebar') do
            yield
          end
        end

        def within_top_menu
          page.within('ul.navbar-nav') do
            yield
          end
        end
      end
    end
  end
end
