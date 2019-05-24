require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Onprem < Staging
        ADDRESS = 'https://onprem.testbed.gitlab.net'.freeze
      end
    end
  end
end
