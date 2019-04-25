require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Preprod < Staging
        ADDRESS = 'https://pre.gitlab.com'.freeze
      end
    end
  end
end
