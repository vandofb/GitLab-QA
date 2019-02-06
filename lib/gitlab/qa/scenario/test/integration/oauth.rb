require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class OAuth < Scenario::Template
            attr_reader :gitlab_name

            def initialize
              @gitlab_name = 'gitlab-oauth'
            end

            def perform(release, *rspec_args)
              Runtime::Env.require_oauth_environment!
              release = Release.new(release)

              Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.network = 'test'
                gitlab.name = gitlab_name

                gitlab.omnibus_config = <<~OMNIBUS
                gitlab_rails['omniauth_enabled'] = true;
                gitlab_rails['omniauth_allow_single_sign_on'] = ['github'];
                gitlab_rails['omniauth_block_auto_created_users'] = false;
                gitlab_rails['omniauth_providers'] = [
                  {
                    name: 'github',
                    app_id: '#{ENV['GITHUB_OAUTH_APP_ID']}',
                    app_secret: '#{ENV['GITHUB_OAUTH_APP_SECRET']}',
                    url: 'https://github.com/',
                    verify_ssl: false,
                    args: { scope: 'user:email' }
                  }
                ];
                OMNIBUS

                gitlab.instance do
                  puts 'Running OAuth specs!'

                  Component::Specs.perform do |specs|
                    specs.suite = 'Test::Integration::OAuth'
                    specs.release = release
                    specs.network = gitlab.network
                    specs.args = [gitlab.address, *rspec_args]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
