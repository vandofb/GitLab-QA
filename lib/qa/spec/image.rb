require 'rspec/core'

module QA
  module Spec
    class Image
      include Scenario::Actable
      class Failure < StandardError; end

      ##
      # This class will be used to spin a docker image with instance tests.
      #
      # In this refactoring step we simply run specs from a new location.

      def test(address, tag)
        cmd = "bin/qa Test::Instance #{address} #{tag}"

        Open3.popen2e(cmd, chdir: 'qa/') do |_in, out, wait|
          out.each { |line| puts line }

          if wait.value.exited? && wait.value.exitstatus.nonzero?
            raise Failure, "Tests for`#{tag}` on `#{address} failed!"
          end
        end
      end
    end
  end
end
