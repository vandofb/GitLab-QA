require 'tmpdir'
require 'fileutils'

module QA
  module Scenario
    module Test
      module Omnibus
        class Upgrade < Scenario::Template
          VOLUMES = { 'config' => '/etc/gitlab',
                      'logs' => '/var/log/gitlab',
                      'data' => '/var/opt/gitlab' }.freeze

          def perform(version) # rubocop:disable Metrics/MethodLength
            test_scenario =
              Scenario::Test::Instance.const_get(version)

            with_temporary_volumes do |volumes|
              test_scenario.perform do |scenario|
                scenario.tag = 'latest'
                scenario.volumes = volumes
              end

              test_scenario.perform do |scenario|
                scenario.tag = 'nightly'
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
