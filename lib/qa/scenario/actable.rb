module QA
  module Scenario
    module Actable
      def act(*args, &block)
        new.tap do |steps|
          return steps.instance_exec(*args, &block)
        end
      end
    end
  end
end
