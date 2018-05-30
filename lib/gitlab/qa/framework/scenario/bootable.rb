require 'optparse'

module Gitlab
  module QA
    module Framework
      module Scenario
        module Bootable
          Option = Struct.new(:name, :arg, :type, :default, :desc)
          DEFAULT_NOT_PASSED = Object.new.freeze

          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
            def launch!(argv = [])
              return perform(*argv) unless has_attributes?

              options_parser.parse!(argv)

              perform(Runtime::Scenario.attributes, *options_parser.default_argv)
            end

            def attribute(name, arg, type: String, default: DEFAULT_NOT_PASSED, desc: '')
              options.push(Option.new(name, arg, type, default, desc))
            end

            def options
              @options ||= []
            end

            def has_attributes?
              options.any?
            end

            def options_parser
              @options_parser ||=
                OptionParser.new do |parser|
                  options.to_a.each do |opt|
                    if opt.default != DEFAULT_NOT_PASSED
                      Runtime::Scenario.define(opt.name, opt.default, type: opt.type)
                    end

                    parser.on(opt.arg, opt.desc) do |value|
                      Runtime::Scenario.define(opt.name, value, type: opt.type)
                    end
                  end
                end
            end
          end
        end
      end
    end
  end
end
