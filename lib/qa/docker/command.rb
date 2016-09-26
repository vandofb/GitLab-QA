require 'open3'

module QA
  module Docker
    class Command
      class CommandError < StandardError; end

      attr_reader :args

      def self.execute(cmd)
        new(cmd).execute!
      end

      def initialize(cmd = nil)
        @args = Array(cmd)
      end

      def <<(args)
        tap { @args << args }
      end

      def execute!
        engine("docker #{@args.join(' ')}")
      end


      private

      def engine(cmd)
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
    end
  end
end
