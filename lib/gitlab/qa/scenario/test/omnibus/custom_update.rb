require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class CustomUpdate < Scenario::Template
            def perform(previous_edition, next_edition)
              previous_release = Release.new(previous_edition).previous_stable
              next_release = Release.new(next_edition)

              Docker::Volumes.new.with_temporary_volumes do |volumes|
                Scenario::Test::Instance::Image
                  .perform(previous_release) do |scenario|
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
