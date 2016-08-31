module QA
  module Scenario
    module Test
      class CE < Scenario::Template
        def perform
          RSpec::Config.act { configure }
          RSpec::Run.act { run_suite(:ee) }
        end
      end
    end
  end
end
