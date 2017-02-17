require 'rspec/core'

module QA
  module Docker
    class Specs
      include Scenario::Actable
      IMAGE_NAME = 'gitlab/gitlab-qa'

      def initialize
        @docker = Docker::Engine.new
      end

      def test(gitlab)
        tag = "#{gitlab.release}-#{gitlab.tag}"
        args = ['Test::Instance', gitlab.address, gitlab.release]

        @docker.run(IMAGE_NAME, tag, *args) do |command|
          command << "-t --rm --net #{gitlab.network}"
          command << "--name #{gitlab.name}-specs"
        end
      end
    end
  end
end
