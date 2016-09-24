require 'rspec/core'

module QA
  module Spec
    class Run
      extend Scenario::Actable

      def instance(tag)
        rspec(tag, 'lib/qa/spec/feature')
      end

      def rspec(tag, location)
        args = ['-c', '--tag', tag.to_s, location].flatten

        status = RSpec::Core::Runner.run(args, $stderr, $stdout)
        abort if status.nonzero?
      end
    end
  end
end
