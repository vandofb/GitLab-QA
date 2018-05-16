require 'securerandom'
require 'net/http'
require 'uri'
require 'forwardable'
require 'ngrok/tunnel'
require 'base64'

module Gitlab
  module QA
    module Component
      class KubernetesCluster
        include Scenario::Actable

        attr_reader :api_url, :ca_certificate, :token

        def initialize
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

        def cluster_name
          @cluster_name ||= "qa-cluster-#{SecureRandom.hex(4)}"
        end

        private

        def start
          result = system("gcloud container clusters create #{cluster_name} --enable-legacy-authorization")
          raise "failed to create K8s cluster" unless result
          result = system("gcloud container clusters get-credentials #{cluster_name}")
          raise "failed to get credentials for K8s cluster" unless result
          @api_url = `kubectl config view -o json --minify |jq .clusters[].cluster.server | tr -d '"'`.chomp
          @ca_certificate = Base64.decode64(`kubectl get secrets -o json | jq '.items[] | .data | ."ca.crt"' | tr -d '"'`)
          @token = Base64.decode64(`kubectl get secrets -o json | jq '.items[] | .data | .token' | tr -d '"'`)
        end

        def teardown
          system("gcloud container clusters delete #{cluster_name} --quiet --async")
        end
      end
    end
  end
end
