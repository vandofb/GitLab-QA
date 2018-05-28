module Gitlab
  module QA
    module Component
      ##
      # This class represents GitLab QA specs image that is implemented in
      # the `qa/` directory located in GitLab CE / EE repositories.
      #
      class Specs
        include Framework::Scenario::Actable

        attr_accessor :suite, :release, :network, :args

        def initialize
          @docker = Docker::Engine.new
        end

        def perform # rubocop:disable Metrics/AbcSize
          raise ArgumentError unless [suite, release].all?

          puts "Running test suite `#{suite}` for #{release.project_name}"

          @docker.run(release.qa_image, release.tag, suite, *args) do |command|
            command << "-t --rm --net=#{network || 'bridge'}"

            variables = Runtime::Env.variables
            variables.each do |key, value|
              command.env(key, value)
            end

            command.volume('/var/run/docker.sock', '/var/run/docker.sock')
            command.volume(Runtime::Env.screenshots_dir, '/home/qa/tmp')
            command.name("gitlab-specs-#{Time.now.to_i}")
          end
        end
      end
    end
  end
end
