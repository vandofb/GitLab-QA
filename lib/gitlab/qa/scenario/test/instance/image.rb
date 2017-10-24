module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Image < Scenario::Template
            attr_writer :volumes

            def initialize
              @volumes = {}
            end

            def perform(release)
              Docker::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.volumes = @volumes
                gitlab.network = 'test'

                gitlab.instance do
                  Docker::Specs.perform do |instance|
                    instance.test(gitlab: gitlab)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
