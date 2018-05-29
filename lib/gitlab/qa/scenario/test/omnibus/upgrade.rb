require 'tmpdir'
require 'fileutils'

module Gitlab
  module QA
    module Scenario
      module Test
        module Omnibus
          class Upgrade
            include Template

            def perform(options, image = 'CE')
              ce_release = Release.new(image)

              if ce_release.ee?
                raise ArgumentError, 'Only CE can be upgraded to EE!'
              end

              volumes = Framework::Docker::Volumes.new(Component::Gitlab::VOLUMES)

              volumes.with_temporary_volumes do |volumes|
                Scenario::Test::Instance::Image
                  .perform(ce_release) do |scenario|
                  scenario.volumes = volumes
                end

                Scenario::Test::Instance::Image
                  .perform(ce_release.to_ee) do |scenario|
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
