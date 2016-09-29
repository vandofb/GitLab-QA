require 'tmpdir'
require 'fileutils'

module QA
  module Scenario
    module Test
      module Omnibus
        class Upgrade < Scenario::Template
          def perform # rubocop:disable Metrics/MethodLength
            within_temporary_directory do |dir|
              Scenario::Test::Instance::CE.perform(dir) do |volumes|
                with_tag('latest')
                with_volume("#{dir}/config", '/etc/gitlab')
                with_volume("#{dir}/logs", '/var/log/gitlab')
                with_volume("#{dir}/data", '/var/opt/gitlab')
              end

              Scenario::Test::Instance::CE.perform(dir) do |volumes|
                with_tag('nightly')
                with_volume("#{dir}/config", '/etc/gitlab')
                with_volume("#{dir}/logs", '/var/log/gitlab')
                with_volume("#{dir}/data", '/var/opt/gitlab')
              end
            end
          end

          def within_temporary_directory
            yield Dir.mktmpdir('gitlab-qa-') if block_given?
          end
        end
      end
    end
  end
end
