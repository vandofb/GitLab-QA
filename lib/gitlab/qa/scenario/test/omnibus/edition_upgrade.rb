require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class EditionUpgrade < Scenario::Template
            VOLUMES = { 'config' => '/etc/gitlab',
                        'logs' => '/var/log/gitlab',
                        'data' => '/var/opt/gitlab' }.freeze

            def perform
              ce = Release.new('CE')

              with_temporary_volumes do |volumes|
                Scenario::Test::Instance::Image
                  .perform(ce) do |scenario|
                  scenario.volumes = volumes
                end

                Scenario::Test::Instance::Image
                  .perform(Release.new('EE')) do |scenario|
                  scenario.volumes = volumes
                end
              end
            end

            def with_temporary_volumes
              # macOS's tmpdir is a symlink /var/folders -> /private/var/folders
              # but Docker on macOS exposes /private and disallow exposing /var/
              # so we need to get the real tmpdir path
              Dir.mktmpdir('gitlab-qa-', File.realpath(Dir.tmpdir)).tap do |dir|
                yield Hash[VOLUMES.map { |k, v| ["#{dir}/#{k}", v] }]
              end
            end
          end
        end
      end
    end
  end
end
