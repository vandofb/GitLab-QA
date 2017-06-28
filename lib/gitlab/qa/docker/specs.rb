module Gitlab
  module QA
    module Docker
      class Specs
        include Scenario::Actable

        IMAGE_NAME = 'gitlab/gitlab-qa'.freeze

        def initialize
          @docker = Docker::Engine.new
        end

        def test(gitlab)
          test_address(gitlab.release.edition, gitlab.tag, gitlab.address,
                       "#{gitlab.name}-specs", gitlab.network)
        end

        # rubocop:disable Metrics/MethodLength
        #
        def test_address(edition, tag, address, name = nil, network = nil)
          puts 'Running instance test scenarios for Gitlab ' \
               "#{edition.upcase} at #{address}"

          args = ['Test::Instance', address]

          @docker.run(IMAGE_NAME, "#{edition}-#{tag}", *args) do |command|
            command << "-t --rm --net=#{network || 'bridge'}"

            Runtime::Env.delegated.each do |env|
              command << %(-e #{env}="$#{env}") if ENV[env]
            end

            command << "-v #{Runtime::Env.screenshots_dir}:/home/qa/tmp"
            command << "--name #{name || ('gitlab-specs-' + Time.now.to_i)}"
          end
        end
      end
    end
  end
end
