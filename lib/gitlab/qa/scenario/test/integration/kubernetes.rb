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
              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'

                Component::Ngrok.perform do |ngrok_gitlab|
                  Component::Ngrok.perform do |ngrok_registry|
                    ngrok_gitlab.gitlab_hostname = gitlab.hostname
                    ngrok_gitlab.network = 'test'
                    ngrok_registry.gitlab_hostname = gitlab.hostname
                    ngrok_registry.network = 'test'

                    gitlab.omnibus_config = <<~OMNIBUS
                      external_url '#{ngrok_gitlab.url}';
                      nginx['listen_port'] = 80;
                      nginx['listen_https'] = false;

                      registry_external_url '#{ngrok_registry.url}';
                      registry_nginx['listen_port'] = 80;
                      registry_nginx['listen_https'] = false;
                    OMNIBUS

                    ngrok_gitlab.instance do
                      ngrok_registry.instance do
                        gitlab.instance do
                          Component::Specs.perform do |specs|
                            specs.suite = 'Test::Integration::Kubernetes'
                            specs.release = gitlab.release
                            specs.network = gitlab.network
                            specs.args = [ngrok_gitlab.url]
                          end
                        end
                      end
                    end
                  end
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
