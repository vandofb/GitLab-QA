module QA
  module Page
    module Main
      class Groups < Page::Base
        def prepare_test_namespace
          return if page.has_content?(Test::Namespace.name)

          click_on 'New Group'

          fill_in 'group_path', with: Test::Namespace.name
          fill_in 'group_description',
                  with: "QA test run at #{Test::Namespace.time}"
          choose 'Private'

          click_button 'Create group'
        end
      end
    end
  end
end
