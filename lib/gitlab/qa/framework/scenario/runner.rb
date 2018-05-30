require 'rspec/core'

module Gitlab
  module QA
    module Framework
      module Scenario
        class Runner
          include Gitlab::QA::Framework::Scenario::Actable

          attr_accessor :tty, :tags, :options

          def initialize
            @tty = false
            @tags = []
            @options = [File.expand_path('../../features', __dir__)]
          end

          def perform
            args = []
            args.push('--tty') if tty
            tags.to_a.each { |tag| args.push(['-t', tag.to_s]) }
            args.push(options)

            Framework::Runtime::Browser.configure!

            RSpec::Core::Runner.run(args.flatten, $stderr, $stdout).tap do |status|
              abort if status.nonzero?
            end
          end
        end
      end
    end
  end
end
