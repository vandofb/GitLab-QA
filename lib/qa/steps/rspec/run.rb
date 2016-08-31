require 'rspec/core'

module QA
  module RSpec
    class Run < RSpec::Base
      def run_suite(tag)
        args = ['--tag', tag.to_s, 'lib/qa/specs']

        status = ::RSpec::Core::Runner.run(args, $stderr, $stdout)

        abort if status.nonzero?
      end
    end
  end
end
