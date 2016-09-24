require 'open3'

module QA
  module Docker
    class Base
      extend Scenario::Actable
      class CommandError < StandardError; end

      def exec(cmd)
        Open3.popen2e(cmd) do |_in, out, wait|
          out.each do |line|
            puts line
            yield line if block_given?
          end

          if wait.value.exitstatus.nonzero?
            raise CommandError, "Docker command `#{cmd}` failed!"
          end
        end
      end

      def docker_host
        ENV['DOCKER_HOST'] || 'http://localhost'
      end
    end
  end
end
