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
                Scenario::Test::Instance::Image
                  .perform(previous_release) do |scenario|
                  scenario.volumes = volumes
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
