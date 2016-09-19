module QA
  module Scenario
    module Test
      module Instance
        class CE < Scenario::Template
          def perform
            Docker::Network.act do
              create('testa') unless exists?('testa')
            end

            Spec::Config.act { configure }
            Spec::Run.act { run_suite(:ce) }
          end
        end
      end
    end
  end
end
