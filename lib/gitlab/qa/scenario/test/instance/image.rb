module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          class Image < Scenario::Template
            attr_writer :tag, :volumes

            def initialize
              @tag = 'nightly'
              @volumes = {}
            end

            # rubocop:disable Metrics/MethodLength
            #
            def perform(version)
              unless %w(CE EE).include?(version)
                raise 'Unknown GitLab release type specified!'
              end

              Docker::Gitlab.perform do |gitlab|
                gitlab.release = version.downcase.to_sym
                gitlab.name = "gitlab-qa-#{gitlab.release}"
                gitlab.image = "gitlab/gitlab-#{gitlab.release}"
                gitlab.tag = @tag
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
