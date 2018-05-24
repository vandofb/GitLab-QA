module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Image < Framework::Scenario::Template
            attr_writer :volumes

            def initialize
              @volumes = {}
            end

            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.volumes = @volumes
                gitlab.network = 'test'

                gitlab.instance do
                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Instance'
                    specs.release = gitlab.release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address]
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
