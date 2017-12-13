module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Image < Scenario::Template
            def perform(release)
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
