require 'open3'

module QA
  module Docker
    class Base
      class CommandError < StandardError; end

      def self.act(*args, &block)
        new.tap do |page|
          return page.instance_exec(*args, &block)
        end
      end

      private

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
    end
  end
end
