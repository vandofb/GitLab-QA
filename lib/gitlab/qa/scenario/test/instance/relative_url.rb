module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class RelativeUrl < Image
            def perform(release)
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'
                gitlab.relative_path = '/relative'

                gitlab.omnibus_config = <<~OMNIBUS
                  external_url '#{gitlab.address}'
                OMNIBUS

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
