module Page
  class Base
    include Capybara::DSL

    def self.on(&block)
      new.instance_eval(&block)
    end
  end
end
