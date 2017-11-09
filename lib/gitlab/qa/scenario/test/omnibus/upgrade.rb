require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Upgrade < Scenario::Template
            VOLUMES = { 'config' => '/etc/gitlab',
                        'logs' => '/var/log/gitlab',
                        'data' => '/var/opt/gitlab' }.freeze

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

            def with_temporary_volumes
              Dir.mktmpdir('gitlab-qa-').tap do |dir|
                yield Hash[VOLUMES.map { |k, v| ["#{dir}/#{k}", v] }]
              end
            end
          end
        end
      end
    end
  end
end
