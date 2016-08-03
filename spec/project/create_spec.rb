require 'spec_helper'

feature 'create a new project', ce: true, ee: true, staging: true do
  scenario 'user creates a new project', js: true do
    Page::Main::Entry.act { sign_in_using_credentials }

    Scenario::Project::Create.perform do |scenario|
      scenario.project_name = 'first_project'
      scenario.project_description = 'awesome project'
    end

    expect(page)
      .to have_content("Project 'first_project' was successfully created.")
    expect(page).to have_content('awesome project')
    expect(page).to have_content('The repository for this project is empty')
  end
end
