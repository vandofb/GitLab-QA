require 'securerandom'
require 'net/http'
require 'uri'
require 'forwardable'
require 'ngrok/tunnel'

module Gitlab
  module QA
    module Component
      class Ngrok
        include Scenario::Actable

        attr_writer :gitlab

        def initialize
        end

        def url
          ::Ngrok::Tunnel.ngrok_url_https
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          start

          yield self

          teardown
        end

        def url
          ::Ngrok::Tunnel.ngrok_url_https
        end

        private

        def start
          raise "Must set gitlab and gitlab.port" unless @gitlab&.port
          ::Ngrok::Tunnel.start(port: @gitlab.port)
        end

        def teardown
          ::Ngrok::Tunnel.stop
        end
      end
    end
  end
end
