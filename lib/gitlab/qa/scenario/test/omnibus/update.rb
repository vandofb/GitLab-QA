require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Update
            include Template

            def perform(options, next_release)
              next_release = Release.new(next_release)
              volumes = Framework::Docker::Volumes.new(Component::Gitlab::VOLUMES)

              volumes.with_temporary_volumes do |volumes|
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
