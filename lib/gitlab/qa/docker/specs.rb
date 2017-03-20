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

        # rubocop:disable Metrics/AbcSize
        # rubocop:disable Metrics/MethodLength
        #
        def test(gitlab)
          tag = "#{gitlab.release}-#{gitlab.tag}"
          args = ['Test::Instance', gitlab.address]

          puts 'Running instance test scenarios for Gitlab ' \
               "#{gitlab.release.upcase} at #{gitlab.address}"

          @docker.run(IMAGE_NAME, tag, *args) do |command|
            command << "-t --rm --net #{gitlab.network}"

            ENVS.each do |env|
              command << %(-e #{env}="$#{env}") if ENV[env]
            end

            command << '-v /tmp/gitlab-qa-screenshots:/home/qa/tmp/'
            command << "--name #{gitlab.name}-specs"
          end
        end

        def test_address(release, tag, address)
          puts 'Running test scenarios for existing Gitlab ' \
               "#{release.upcase} instance at #{address}"

          args = ['Test::Instance', address]

          @docker.run(IMAGE_NAME, "#{release}-#{tag}", *args) do |command|
            command << %(-t --rm)

            ENVS.each do |env|
              command << %(-e #{env}="$#{env}") if ENV[env]
            end

            command << '-v /tmp/gitlab-qa-screenshots:/home/qa/tmp/'
            command << "--name gitlab-specs-#{Time.now.to_i}"
          end
        end
      end
    end
  end
end
