module QA
  module Scenario
    module Test
      module Omnibus
        class Image < Scenario::Template
          def perform
            Docker::Gitlab.act do
              with_name('gitlab-qa-ce')
              with_image('gitlab/gitlab-ce')
              with_image_tag('nightly')
              within_network('bridge')

              reconfigure do |line|
                teardown if line =~ /gitlab Reconfigured!/
              end
            end
          end
        end
      end
    end
  end
end
