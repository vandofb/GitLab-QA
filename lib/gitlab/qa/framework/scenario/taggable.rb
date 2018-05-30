module Gitlab
  module QA
    module Framework
      module Scenario
        module Taggable
          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
            def tags(*tags)
              @tags = tags # rubocop:disable Gitlab/ModuleWithInstanceVariables
            end

            def focus
              @tags.to_a # rubocop:disable Gitlab/ModuleWithInstanceVariables
            end
          end
        end
      end
    end
  end
end
