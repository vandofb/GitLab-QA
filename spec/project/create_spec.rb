require 'spec_helper'

feature 'create a new project', ce: true, ee: true, staging: true do
  scenario 'user creates a new project', js: true do
    Page::Main.on { sign_in_using_credentials }
    Page::Menu.on { go_to_groups }
    Page::Groups.on { prepare_test_namespace }
    Page::Menu.on { go_to_projects }
    Page::Projects.on { click_new_project }

    Page::Project::New.on do
      choose_test_namespace
      choose_name('first_project')
      add_description('awesome project')
      create_new_project
    end

    expect(page)
      .to have_content("Project 'first_project' was successfully created.")
    expect(page).to have_content('awesome project')
    expect(page).to have_content('The repository for this project is empty')
  end
end
