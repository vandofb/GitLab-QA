module QA
  feature 'create a new project', :ce, :ee, :staging do
    scenario 'user creates a new project' do
      Page::Main::Entry.act { sign_in_using_credentials }

      Scenario::Project::Create.perform do
        with_project_name('awesome-project')
        with_project_description 'create awesome project test'
      end

      expect(page).to have_content(
        /Project 'awesome-project-\h+' was successfully created/
      )

      expect(page).to have_content('create awesome project test')
      expect(page).to have_content('The repository for this project is empty')
    end
  end
end
