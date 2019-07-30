module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Elasticsearch < Scenario::Template
            attr_reader :gitlab_name, :spec_suite

            def initialize
              @gitlab_name = 'gitlab-elastic'
              @spec_suite = 'QA::EE::Scenario::Test::Integration::Elasticsearch'
            end

            def before_perform(release)
              raise ArgumentError, 'Elasticsearch is an EE only feature!' unless release.ee?
            end

            def perform(release, *rspec_args)
              release = Release.new(release)
              before_perform(release)

              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                setup_elasticsearch_on gitlab

                Component::Elasticsearch.perform do |elastic|
                  elastic.network = 'test'
                  elastic.instance do
                    gitlab.instance do
                      puts "Running #{spec_suite} specs!"

                      Component::Specs.perform do |specs|
                        specs.suite = spec_suite
                        specs.release = gitlab.release
                        specs.network = gitlab.network
                        specs.args = [gitlab.address, *rspec_args]
                      end
                    end
                  end
                end
              end
            end

            def empty_index
              @empty_index ||= ["gitlab-rake gitlab:elastic:create_empty_index"]
            end

            def setup_elasticsearch_on(instance)
              instance.name = gitlab_name
              instance.network = 'test'
              instance.elastic_url = 'http://elastic68:9200'
              instance.exec_commands = empty_index
            end
          end
        end
      end
    end
  end
end
