module Gitlab
  module QA
    module Framework
      module Runtime
        class Address
          attr_reader :address

          def initialize(instance, page = nil)
            @instance = instance
            @address  = host + (page.is_a?(String) ? page : page&.path)
          end

          def host
            if @instance.is_a?(Symbol)
              Scenario.send("#{@instance}_address")
            else
              @instance.to_s
            end
          end
        end
      end
    end
  end
end
