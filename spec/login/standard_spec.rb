feature 'standard root login', ce: true, ee: true do
  scenario 'user logs in using credentials' do
    Page::Main::Entry.on { sign_in_using_credentials }

    expect(page).to have_content('Signed in successfully.')
  end
end
