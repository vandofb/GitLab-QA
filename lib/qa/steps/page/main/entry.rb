module QA
  module Page
    module Main
      class Entry < Page::Base
        def initialize
          visit('/')

          # This resolves cold boot problems with login page
          find('#tanuki-logo', wait: 120)
        end

        def sign_in_using_credentials
          if page.has_content?('Change your password')
            fill_in 'New password', with: Run::User.password
            fill_in 'Confirm new password', with: Run::User.password
            click_button 'Change your password'
          end

          fill_in 'Username or Email', with: Run::User.name
          fill_in 'Password', with: Run::User.password
          click_button 'Sign in'
        end
      end
    end
  end
end
