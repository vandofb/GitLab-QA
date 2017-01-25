module QA
  module Scenario
    module Test
      module Instance
        class Gitlab < Scenario::Template
          attr_writer :tag, :volumes

          def initialize
            @tag = 'nightly'
            @volumes = {}
          end

          def perform(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
