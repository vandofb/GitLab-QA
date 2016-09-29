module QA
  module Scenario
    module Test
      module Instance
        class Gitlab < Scenario::Template
          def initialize
            @tag = 'nightly'
            @volumes = {}
          end

          def perform(*)
            raise NotImplementedError
          end

          def with_tag(tag)
            @tag = tag
          end

          def with_volume(to, from)
            @volumes.store(to, from)
          end
        end
      end
    end
  end
end
