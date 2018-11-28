require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Production < Staging
        ADDRESS = 'https://gitlab.com'.freeze
      end
    end
  end
end
