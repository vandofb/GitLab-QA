require 'tmpdir'
require 'fileutils'

module QA
  module Scenario
    module Test
      module Omnibus
        class Upgrade < Scenario::Template
          def perform # rubocop:disable Metrics/MethodLength
            within_temporary_directory do |dir|
              volumes = { "#{dir}/config" => '/etc/gitlab',
                          "#{dir}/logs" => '/var/log/gitlab',
                          "#{dir}/data" => '/var/opt/gitlab' }

              Scenario::Test::Instance::CE.perform(volumes) do |volumes|
                with_tag('latest')
                with_volumes(volumes)
              end

              Scenario::Test::Instance::CE.perform(volumes) do |volumes|
                with_tag('nightly')
                with_volumes(volumes)
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
