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
                  ngrok_gitlab.port = gitlab.port

                  ngrok_gitlab.instance do
                    Component::Ngrok.perform do |ngrok_registry|
                      ngrok_registry.port = gitlab.port

                      ngrok_registry.instance do
                        gitlab.omnibus_config = <<~OMNIBUS
                          external_url '#{ngrok_gitlab.url}';
                          nginx['listen_port'] = 80;
                          nginx['listen_https'] = false;

                          registry_external_url '#{ngrok_registry.url}';
                          registry_nginx['listen_port'] = 80;
                          registry_nginx['listen_https'] = false;
                        OMNIBUS

                        gitlab.instance do
                          require 'pry'; binding.pry

                          #puts 'Running Kubernetes specs!'

                          #Component::Specs.perform do |specs|
                          #  specs.suite = 'Test::Integration::Kubernetes'
                          #  specs.release = gitlab.release
                          #  specs.network = gitlab.network
                          #  specs.args = [gitlab.address]
                          #end
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
