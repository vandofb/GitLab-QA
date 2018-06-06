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

                Component::InternetTunnel.perform do |tunnel_gitlab|
                  Component::InternetTunnel.perform do |tunnel_registry|
                    tunnel_gitlab.gitlab_hostname = gitlab.hostname
                    tunnel_gitlab.network = 'test'
                    tunnel_registry.gitlab_hostname = gitlab.hostname
                    tunnel_registry.network = 'test'

                    gitlab.omnibus_config = <<~OMNIBUS
                      external_url '#{tunnel_gitlab.url}';
                      nginx['listen_port'] = 80;
                      nginx['listen_https'] = false;

                      registry_external_url '#{tunnel_registry.url}';
                      registry_nginx['listen_port'] = 80;
                      registry_nginx['listen_https'] = false;
                    OMNIBUS

                    tunnel_gitlab.instance do
                      tunnel_registry.instance do

                        gitlab.instance do
                          Component::Specs.perform do |specs|
                            specs.suite = 'Test::Integration::Kubernetes'
                            specs.release = gitlab.release
                            specs.network = gitlab.network
                            specs.args = [tunnel_gitlab.url]
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
