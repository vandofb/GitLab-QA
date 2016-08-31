module QA
  module Page
    module Main
      class Groups < Page::Base
        def prepare_test_namespace
          return if page.has_content?(Run::Namespace.name)

          click_on 'New Group'

          fill_in 'group_path', with: Run::Namespace.name
          fill_in 'group_description',
                  with: "QA test run at #{Run::Namespace.time}"
          choose 'Private'

          click_button 'Create group'
        end
      end
    end
  end
end
