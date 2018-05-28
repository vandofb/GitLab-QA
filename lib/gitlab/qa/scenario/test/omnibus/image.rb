module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Image
            include Gitlab::QA::Framework::Scenario::Template

            def perform(options, release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'bridge'

                gitlab.act do
                  prepare
                  start
                  reconfigure

                  restart
                  wait
                  teardown
                end
              end
            end
          end
        end
      end
    end
  end
end
