module Gitlab
  module QA
    module Docker
      class Command
        attr_reader :args

        def initialize(cmd = nil)
          @args = Array(cmd)
        end

        def <<(*args)
          tap { @args.concat(args) }
        end

        def volume(from, to)
          tap { @args << "-v #{from}:#{to}" }
        end

        def name(identity)
          tap { @args << "--name #{identity}" }
        end

        def env(name, value)
          tap { @args << %(-e #{name}="#{value}") }
        end

        def to_s
          "docker #{@args.join(' ')}"
        end

        def execute!(&block)
          Docker::Shellout.execute!(self, &block)
        end

        def self.execute(cmd, &block)
          new(cmd).execute!(&block)
        end
      end
    end
  end
end
