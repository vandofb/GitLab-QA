require 'tmpdir'
require 'fileutils'

module QA
  module Scenario
    module Test
      module Omnibus
        class Upgrade < Scenario::Template
          # rubocop:disable Metrics/MethodLength

          def perform(version)
            instance_test_scenario =
              Scenario::Test::Instance.const_get(version.upcase)

            within_temporary_directory do |dir|
              instance_test_scenario.perform do |instance|
                instance.with_tag('latest')
                instance.with_volume("#{dir}/config", '/etc/gitlab')
                instance.with_volume("#{dir}/logs", '/var/log/gitlab')
                instance.with_volume("#{dir}/data", '/var/opt/gitlab')
              end

              instance_test_scenario.perform do |instance|
                instance.with_tag('nightly')
                instance.with_volume("#{dir}/config", '/etc/gitlab')
                instance.with_volume("#{dir}/logs", '/var/log/gitlab')
                instance.with_volume("#{dir}/data", '/var/opt/gitlab')
              end
            end
          end

          def within_temporary_directory
            yield Dir.mktmpdir('gitlab-qa-')
          end
        end
      end
    end
  end
end
