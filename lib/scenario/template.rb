module Scenario
  class Template
    def self.perform(&block)
      new.tap do |scenario|
        scenario.instance_eval(&block)
        return scenario.perform
      end
    end

    def perform
      raise NotImplementedError
    end
  end
end
