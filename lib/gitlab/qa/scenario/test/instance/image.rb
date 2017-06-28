module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Image < Scenario::Template
            attr_writer :tag, :volumes

            def initialize
              @volumes = {}
            end

            # rubocop:disable Metrics/MethodLength
            #
            def perform(release)
              Docker::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.name = "gitlab-qa-#{gitlab.release.edition}"
                gitlab.image = gitlab.release.image
                gitlab.tag = gitlab.release.tag
                gitlab.volumes = @volumes
                gitlab.network = 'test'

                gitlab.instance do
                  Docker::Specs.perform do |instance|
                    instance.test(gitlab)
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
