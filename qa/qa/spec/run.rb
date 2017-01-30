require 'rspec/core'

module QA
  module Spec
    class Run
      include Scenario::Actable

      def rspec(*args)
        RSpec::Core::Runner.run(args.flatten, $stderr, $stdout).tap do |status|
          abort if status.nonzero?
        end
      end
    end
  end
end
