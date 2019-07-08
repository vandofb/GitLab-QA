require 'net/http'
require 'json'
require 'uri'

module Gitlab
  module QA
    module Component
      class Staging
        ADDRESS = 'https://staging.gitlab.com'.freeze
        def self.release
          # Auto-deploy builds have a tag formatted like 12.0.12345+5159f2949cb.59c9fa631
          # but the version api returns a semver version like 12.0.1
          # so images are tagged using minor and major semver components plus
          # the EE commit ref, which is the 'revision' returned by the API
          # and so the version used for the docker image tag is like 12.0-5159f2949cb
          # See: https://gitlab.com/gitlab-org/quality/staging/issues/56
          version = Version.new(address).major_minor_revision
          image =
            if Runtime::Env.dev_access_token_variable
              "dev.gitlab.org:5005/gitlab/omnibus-gitlab/gitlab-ee:#{version}"
            else
              "ee:#{version}"
            end

          Release.new(image)
        rescue InvalidResponseError => ex
          warn ex.message
          warn "#{ex.response.code} #{ex.response.message}: #{ex.response.body}"
          exit 1
        end

        def self.address
          self::ADDRESS
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
              JSON.parse(response.body)
            else
              raise InvalidResponseError.new(@uri.to_s, response)
            end
          end

          def major_minor_revision
            api_response = fetch!
            version_regexp = /^v?(?<major>\d+)\.(?<minor>\d+)\.\d+/
            match = version_regexp.match(api_response.fetch('version'))

            "#{match[:major]}.#{match[:minor]}-#{api_response.fetch('revision')}"
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
