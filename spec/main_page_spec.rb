require 'spec_helper'

feature 'main page' do
  scenario 'user visits main page', only: :ce do
    visit '/'

    expect(page).to have_content('GitLab Community Edition')
  end
end
