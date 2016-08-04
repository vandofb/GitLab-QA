feature 'push code to repository', ce: true, ee: true, staging: true do
  scenario 'user pushes to the repository over http with regular account' do
    Page::Main::Entry.act { sign_in_using_credentials }

    Scenario::Project::Create.perform do |scenario|
      scenario.project_name = 'project_with_code'
      scenario.project_description = 'project with repository'
    end

    uri = Page::Project::Show.act do
      choose_repository_clone_http
      repository_clone_uri
    end

    Git::Repository.act(repository: uri) do
      with_username(Run::User.name)
      with_password(Run::User.password)
      with_location(@repository)

      clone_over_https
    end
  end
end
