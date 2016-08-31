module QA
  module RSpec
    class Base
      def self.act(*args, &block)
        new.tap do |page|
          return page.instance_exec(*args, &block)
        end
      end
    end
  end
end
