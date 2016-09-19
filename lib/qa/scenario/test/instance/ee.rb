module QA
  module Scenario
    module Test
      module Instance
        class EE < Scenario::Template
          def perform
            RSpec::Config.act { configure }
            Scenario::License::Add.perform
            RSpec::Run.act { run_suite(:ee) }
          rescue
            Capybara::Screenshot.screenshot_and_save_page
            raise
          end
        end
      end
    end
  end
end
