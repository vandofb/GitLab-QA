feature 'push code to repository', :ce, :ee, :staging do
  context 'with regular account over http' do
    scenario 'user pushes code to the repository' do
      Page::Main::Entry.act { sign_in_using_credentials }

      Scenario::Project::Create.perform do
        with_project_name 'project_with_code'
        with_project_description 'project with repository'
      end

      location = Page::Project::Show.act do
        choose_repository_clone_http
        repository_clone_uri
      end

      Git::Repository.act(location) do |repository|
        with_location(repository)
        with_default_credentials

        clone_repository
        configure_identity('GitLab QA', 'root@gitlab.com')
        add_file('README.md', '# This is test project')
        commit('Add README.md')
        push_changes
      end

      Page::Project::Show.act do
        sleep 5
        refresh
      end

      expect(page).to have_content('README.md')
      expect(page).to have_content('This is test project')
    end
  end
end
