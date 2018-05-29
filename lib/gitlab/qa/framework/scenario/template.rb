module Gitlab
  module QA
    module Framework
      module Scenario
        module Template
          def self.included(base)
            base.include Gitlab::QA::Framework::Scenario::Actable
            base.include Gitlab::QA::Framework::Scenario::Bootable
          end
        end
      end
    end
  end
end
