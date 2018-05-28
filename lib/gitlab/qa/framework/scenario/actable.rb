module Gitlab
  module QA
    module Framework
      module Scenario
        module Actable
          def self.included(base)
            base.extend(ClassMethods)
          end

          def act(*args, &block)
            instance_exec(*args, &block)
          end

          module ClassMethods
            def perform(*args)
              new.tap do |actor|
                block_result = yield actor if block_given?
                actor.perform(*args) if actor.respond_to?(:perform)
                return block_result
              end
            end

            def act(*args, &block)
              new.act(*args, &block)
            end
          end
        end
      end
    end
  end
end
