module Page
  class Base
    include Capybara::DSL

    def self.act(**variables, &block)
      new.tap do |page|
        variables.each do |variable, value|
          page.instance_variable_set("@#{variable}", value)
        end

        return page.instance_eval(&block)
      end
    end
  end
end
