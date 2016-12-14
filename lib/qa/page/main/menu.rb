module QA
  module Page
    module Main
      class Menu < Page::Base
        include ::RSpec::Matchers

        def go_to_groups
          within_sidebar_menu { click_link 'Groups' }
        end

        def go_to_projects
          within_sidebar_menu { click_link 'Projects' }
        end

        def go_to_admin_area
          within_personal_menu { click_link 'Admin Area' }
        end

        def sign_out
          within_personal_menu do
            find('.header-user-dropdown-toggle').click
            click_link('Sign out')
          end
        end

        def has_personal_menu?
          page.has_selector?('.header-user-dropdown-toggle')
        end

        private

        def within_sidebar_menu
          find('.side-nav-toggle').click

          page.within('.nav-sidebar') do
            yield
          end
        end

        def within_personal_menu
          page.within('ul.navbar-nav') do
            yield
          end
        end
      end
    end
  end
end
