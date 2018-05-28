module Gitlab
  module QA
    module Framework
      module Runtime
        ##
        # Singleton approach to global test scenario arguments.
        #
        module Scenario
          extend self

          def attributes
            @attributes ||= {}
          end

          def define(attribute, value, **opts)
            attribute_sym = attribute.to_sym
            attributes.store(attribute_sym, value)

            return if respond_to?(attribute)

            define_singleton_method(attribute) do
              attributes[attribute_sym].tap do |val|
                if opts[:type] != :flag && val.to_s.empty?
                  raise ArgumentError, "Empty `#{attribute}` attribute!"
                end
              end
            end
          end

          def clear_attributes
            @attributes = {}
          end

          def method_missing(name, *args)
            return yield if block_given?

            raise ArgumentError, "Scenario attribute `#{name}` not defined!"
          end
        end
      end
    end
  end
end
