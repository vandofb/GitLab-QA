require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Staging
        ADDRESS = 'https://staging.gitlab.com'.freeze

        def self.release
          version = Version.new(ADDRESS).fetch!

          Release.new("EE:#{version}")
        rescue InvalidResponseError => ex
          warn ex.message
          warn "#{ex.response.code} #{ex.response.message}: #{ex.response.body}"
          exit 1
        end

        class InvalidResponseError < StandardError
          attr_reader :response

          def initialize(address, response)
            @response = response

            super "Invalid response received from #{address}"
          end
        end

        class Version
          def initialize(address)
            @uri = URI.join(address, '/api/v4/version')
          end

          def fetch!
            response =
              Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
                http.request(request)
              end

            case response
            when Net::HTTPSuccess
              JSON.parse(response.body).fetch('version')
            else
              raise InvalidResponseError.new(@uri.to_s, response)
            end
          end

          private

          def request
            Runtime::Env.require_qa_access_token!

            @request ||= Net::HTTP::Get.new(@uri.path).tap do |req|
              req['PRIVATE-TOKEN'] = Runtime::Env.qa_access_token
            end
          end
        end
      end
    end
  end
end
