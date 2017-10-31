require 'open3'

module Gitlab
  module QA
    module Docker
      class Shellout
        class StatusError < StandardError; end

        def self.execute!(command)
          puts "Running shell command: `#{command}`"

          Open3.popen2e(command.to_s) do |_in, out, wait|
            out.each do |line|
              puts line

              yield line, wait if block_given?
            end

            if wait.value.exited? && wait.value.exitstatus.nonzero?
              raise StatusError, "Docker command `#{command}` failed!"
            end
          end
        end
      end
    end
  end
end
