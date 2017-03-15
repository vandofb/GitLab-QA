module Gitlab
  module QA
    module Docker
      class Specs
        include Scenario::Actable

        IMAGE_NAME = 'gitlab/gitlab-qa'.freeze

        attr_accessor :env

        def initialize
          @docker = Docker::Engine.new
        end

        # rubocop:disable Metrics/AbcSize
        #
        def test(gitlab)
          tag = "#{gitlab.release}-#{gitlab.tag}"
          args = ['Test::Instance', gitlab.address]

          puts 'Running instance test scenarios for Gitlab ' \
               "#{gitlab.release.upcase} at #{gitlab.address}"

          @docker.run(IMAGE_NAME, tag, *args) do |command|
            command << "-t --rm --net #{gitlab.network}"
            command << %(-e #{env}="$#{env}") if env
            command << "--name #{gitlab.name}-specs"
          end
        end
      end
    end
  end
end
