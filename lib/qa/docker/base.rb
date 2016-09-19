require 'open3'

module QA
  module Docker
    class Base
      def self.act(*args, &block)
        new.tap do |page|
          return page.instance_exec(*args, &block)
        end
      end

      private

      def exec(cmd)
        Open3.popen2(cmd) do |_in, out, wait|
          out.each do |line|
            yield line if block_given?
          end

          if wait.value.exitstatus.nonzero?
            raise "Docker command `#{cmd}` failed!"
          end
        end
      end
    end
  end
end
