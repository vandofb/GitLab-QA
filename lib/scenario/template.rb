module Scenario
  class Template
    def self.perform(&block)
      new.tap do |scenario|
        block.call(scenario)
        scenario.perform
      end
    end

    def perform
      raise NotImplementedError
    end
  end
end
