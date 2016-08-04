module Page
  module Project
    class Show < Page::Base
      def choose_repository_clone_http
        find('#clone-dropdown').click

        page.within('#clone-dropdown') do
          find('span', text: 'HTTP').click
        end
      end

      def repository_clone_uri
        find('#project_clone').value
      end
    end
  end
end
