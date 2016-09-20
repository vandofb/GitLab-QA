require 'rspec/core'

module QA
  module Spec
    class Run < Spec::Base
      def run_suite(tag)
        args = ['--tag', tag.to_s, 'lib/qa/spec/feature']

        status = ::RSpec::Core::Runner.run(args, $stderr, $stdout)

        abort if status.nonzero?
      end
    end
  end
end
