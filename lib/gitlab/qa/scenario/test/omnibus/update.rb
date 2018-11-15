require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Update < Scenario::Template
            def perform(from_release, to_release = nil)
              previous_release = Release.new(from_release).previous_stable
              current_release = Release.new(to_release || from_release)

              Docker::Volumes.new.with_temporary_volumes do |volumes|
                Component::Gitlab.perform do |gitlab|
                  gitlab.release = previous_release
                  gitlab.volumes = volumes
                  gitlab.network = 'test'
                  gitlab.launch_and_teardown_instance
                end

                Scenario::Test::Instance::Image
                  .perform(current_release) do |scenario|
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
