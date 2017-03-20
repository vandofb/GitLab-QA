module Gitlab
  module QA
    module Docker
      class Specs
        include Scenario::Actable

        IMAGE_NAME = 'gitlab/gitlab-qa'.freeze

        ENVS = %w(GITLAB_USERNAME GITLAB_PASSWORD
                  GITLAB_URL EE_LICENSE).freeze

        def initialize
          @docker = Docker::Engine.new
        end

        def test(gitlab)
          test_address(gitlab.release, gitlab.tag, gitlab.address,
                       "#{gitlab.name}-specs", gitlab.network)
        end

        # rubocop:disable Metrics/MethodLength
        #
        def test_address(release, tag, address, name = nil, network = nil)
          puts 'Running instance test scenarios for Gitlab ' \
               "#{release.upcase} at #{address}"

          args = ['Test::Instance', address]

          @docker.run(IMAGE_NAME, "#{release}-#{tag}", *args) do |command|
            command << %(-t --rm)
            command << "--net=#{network}" if network

            ENVS.each do |env|
              command << %(-e #{env}="$#{env}") if ENV[env]
            end

            command << '-v /tmp/gitlab-qa-screenshots:/home/qa/tmp/'
            command << "--name #{name || ('gitlab-specs-' + Time.now.to_i)}"
          end
        end
      end
    end
  end
end
