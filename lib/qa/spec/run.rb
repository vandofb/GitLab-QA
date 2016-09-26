require 'rspec/core'

module QA
  module Spec
    class Run
      extend Scenario::Actable

      def instance(tag)
        rspec(['--tag', tag.to_s, 'lib/qa/spec/feature'])
      end

      def rspec(args)
        status = RSpec::Core::Runner.run(args, $stderr, $stdout)
        abort if status.nonzero?
      end
    end
  end
end
