require 'json'
require 'net/http'
require 'cgi'

module Gitlab
  module QA
    module Scenario
      module Test
        module Template
          def self.included(base)
            base.include Gitlab::QA::Framework::Scenario::Actable
            base.include Gitlab::QA::Framework::Scenario::Bootable
            base.attribute :skip_pull?, '--skip-pull', type: :flag, default: false
          end
        end
      end
    end
  end
end
