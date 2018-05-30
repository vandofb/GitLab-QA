require 'open3'

module Gitlab
  module QA
    module Framework
      module Utils
        class Shellout
          StatusError = Class.new(StandardError)

          def initialize(command)
            @command = command
            @output = []

            puts "Command: `#{@command}`"
          end

          def execute!
            raise StatusError, 'Command already executed' if @output.any?

            Open3.popen2e(@command.to_s) do |_in, out, wait|
              out.each do |line|
                @output.push(line)

                if block_given?
                  yield line, wait
                else
                  puts line
                end
              end

              if wait.value.exited? && wait.value.exitstatus.nonzero?
                raise StatusError, "Command `#{@command}` failed!"
              end
            end

            @output.join.chomp
          end
        end
      end
    end
  end
end
