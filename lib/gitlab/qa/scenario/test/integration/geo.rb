module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Geo < Scenario::Template
            # rubocop:disable Metrics/MethodLength
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
              end
            end
          end
        end
      end
    end
  end
end
