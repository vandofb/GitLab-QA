module QA
  module Scenario
    module Test
      module Instance
        class CE < Scenario::Template
          def perform
            RSpec::Config.act { configure }
            RSpec::Run.act { run_suite(:ce) }
          end
        end
      end
    end
  end
end
