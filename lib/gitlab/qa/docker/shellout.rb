require 'open3'

module Gitlab
  module QA
    module Docker
      class Shellout
        class StatusError < StandardError; end

        def self.execute!(cmd)
          puts "Running shell command: `#{cmd}`"

          Open3.popen2e(@command) do |_in, out, wait|
            out.each do |line|
              puts line

              yield line, wait if block_given?
            end

            if wait.value.exited? && wait.value.exitstatus.nonzero?
              raise StatusError, "Docker command `#{cmd}` failed!"
            end
          end
        end
      end
    end
  end
end
