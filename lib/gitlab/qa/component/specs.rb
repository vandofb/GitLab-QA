require 'securerandom'

module Gitlab
  module QA
    module Component
      ##
      # This class represents GitLab QA specs image that is implemented in
      # the `qa/` directory located in GitLab CE / EE repositories.
      #
      class Specs < Scenario::Template
        attr_accessor :suite, :release, :network, :args

        def initialize
          @docker = Docker::Engine.new
        end

        def perform # rubocop:disable Metrics/AbcSize
          raise ArgumentError unless [suite, release].all?

          qa_run_name = "gitlab-#{release.edition}-qa-#{SecureRandom.hex(4)}"
          puts "Running test suite `#{suite}` (#{qa_run_name}) for #{release.project_name}"

          @docker.run(release.qa_image, release.qa_tag, suite, *args) do |command|
            command << "-t --rm --net=#{network || 'bridge'}"

            variables = Runtime::Env.variables
            variables.each do |key, value|
              command.env(key, value)
            end

            command.volume('/var/run/docker.sock', '/var/run/docker.sock')

            host_artifacts_dir = File.join(Runtime::Env.artifacts_dir, qa_run_name)
            command.volume(host_artifacts_dir, '/home/qa/tmp')

            command.name(qa_run_name)
          end
        end
      end
    end
  end
end
