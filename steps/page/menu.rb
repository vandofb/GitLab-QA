module Page
  class Menu < Base
    def initialize
      find('.side-nav-toggle').click
    end

    def go_to_groups
      menu { click_link 'Groups' }
    end

    def go_to_projects
      menu { click_link 'Projects' }
    end

    private

    def menu
      page.within('ul.nav-sidebar') do
        yield
      end
    end
  end
end
