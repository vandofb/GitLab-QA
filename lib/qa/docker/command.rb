require 'open3'

module QA
  module Docker
    class Command
      class StatusError < StandardError; end

      attr_reader :args

      def self.execute(cmd, &block)
        new(cmd).execute!(&block)
      end

      def initialize(cmd = nil)
        @args = Array(cmd)
      end

      def <<(args)
        tap { @args << args }
      end

      def execute!(&block)
        engine("docker #{@args.join(' ')}", &block)
      end

      private

      def engine(cmd)
        puts "Running shell command: `#{cmd}`"

        Open3.popen2e(cmd) do |_in, out, wait|
          out.each do |line|
            puts line
            yield line if block_given?
          end

          if wait.value.exitstatus.nonzero?
            raise StatusError, "Docker command `#{cmd}` failed!"
          end
        end
      end
    end
  end
end
