module QA
  module Scenario
    module Test
      module Instance
        class EE < Scenario::Template
          def perform
            Spec::Config.act { configure }
            Scenario::License::Add.perform
            Spec::Run.act { run_suite(:ee) }
          end
        end
      end
    end
  end
end
