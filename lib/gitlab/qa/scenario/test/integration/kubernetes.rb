require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Kubernetes < Scenario::Template
            CERT_PATH = File.expand_path('../../../../../../fixtures/cert'.freeze, __dir__)

            # rubocop:disable Metrics/AbcSize
            def perform(release)
              #external_domain = ENV['EXTERNAL_DOMAIN_NAME'] || raise("misconfigured")
              #ssl_certificate = $ENV["REGISTRY_SSL_CERTIFICATE"] || raise("misconfigured")
              #ssl_certificate_key = $ENV["REGISTRY_SSL_CERTIFICATE_KEY"] || raise("misconfigured")

              Component::KubernetesCluster.perform do |cluster|
                cluster.instance do

                  require 'pry'; binding.pry


           #       Component::Gitlab.perform do |gitlab|
           #         gitlab.release = release
           #         gitlab.network = 'test'

           #         Component::Ngrok.perform do |ngrok_gitlab|
           #           ngrok_gitlab.gitlab = gitlab

           #           ngrok_gitlab.instance do
           #             Component::Ngrok.perform do |ngrok_registry|
           #               ngrok_registry.gitlab = gitlab

           #               ngrok_registry.instance do
           #                 gitlab.omnibus_config = <<~OMNIBUS
           #                 #external_url '#{ngrok_gitlab.url}';
           #                 #nginx['listen_port'] = 80;
           #                 #nginx['listen_https'] = false;

           #                 registry_external_url '#{ngrok_registry.url}';
           #                 registry_nginx['listen_port'] = 80;
           #                 registry_nginx['listen_https'] = false;
           #                 OMNIBUS

           #                 gitlab.instance do
           #                   require 'pry'; binding.pry
           #                 end
           #               end
           #             end
           #           end
           #         end
           #       end
                end
              end
            end
            # rubocop:enable Metrics/AbcSize
          end
        end
      end
    end
  end
end
