module Page
  module Main
    class Groups < Page::Base
      module TestNamespace
        extend self

        def time
          @time ||= Time.now
        end

        def name
          'qa_test_' + time.strftime('%d_%m_%Y_%H-%M-%S')
        end
      end

      def prepare_test_namespace
        return if page.has_content?(TestNamespace.name)

        click_on 'New Group'

        fill_in 'group_path', with: TestNamespace.name
        fill_in 'group_description',
                with: "QA test run at #{TestNamespace.time}"
        choose 'Private'

        click_button 'Create group'
      end
    end
  end
end
