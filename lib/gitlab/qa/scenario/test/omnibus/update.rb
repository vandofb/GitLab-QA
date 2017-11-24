require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Update < Scenario::Template
            include WithTempVolumes

            def perform(next_release)
              next_release = Release.new(next_release)

              with_temporary_volumes do |volumes|
                Scenario::Test::Instance::Image
                  .perform(next_release.previous_stable) do |scenario|
                  scenario.volumes = volumes
                end

                Scenario::Test::Instance::Image
                  .perform(next_release) do |scenario|
                  scenario.volumes = volumes
                end
              end
            end
          end
        end
      end
    end
  end
end
