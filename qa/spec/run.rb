require 'rspec/core'

module QA
  module Spec
    class Run
      include Scenario::Actable

      def test_instance(tag)
        rspec('--tag', tag.to_s, 'lib/qa/spec/feature')
      end

      def rspec(*args)
        RSpec::Core::Runner.run(args.flatten, $stderr, $stdout).tap do |status|
          abort if status.nonzero?
        end
      end
    end
  end
end
