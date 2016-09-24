module QA
  module Page
    class Base
      include Capybara::DSL
      extend Scenario::Actable

      def refresh
        visit current_path
      end
    end
  end
end
