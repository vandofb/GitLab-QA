module Page
  class Base
    include Capybara::DSL

    def self.act(*variables, &block)
      new.tap do |page|
        return page.instance_exec(*variables, &block)
      end
    end

    def refresh
      visit current_path
    end
  end
end
