module Gitlab
  module QA
    module Framework
      module Docker
        class Command
          attr_reader :args

          def initialize(cmd = nil)
            @args = Array(cmd)
          end

          def <<(*args)
            tap { @args.concat(args) }
          end

          def volume(from, to, opt = :z)
            tap { @args.push("--volume #{from}:#{to}:#{opt}") }
          end

          def name(identity)
            tap { @args.push("--name #{identity}") }
          end

          def env(name, value)
            tap { @args.push(%(--env #{name}="#{value}")) }
          end

          def to_s
            "docker #{@args.join(' ')}"
          end

          def ==(other)
            to_s == other.to_s
          end

          def execute!(&block)
            Shellout.new(self).execute!(&block)
          end

          def self.execute(cmd, &block)
            new(cmd).execute!(&block)
          end
        end
      end
    end
  end
end
