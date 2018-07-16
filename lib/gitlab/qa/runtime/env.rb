require 'securerandom'

module Gitlab
  module QA
    module Runtime
      module Env
        extend self

        ENV_VARIABLES = {
          'GITLAB_USERNAME' => :user_username,
          'GITLAB_PASSWORD' => :user_password,
          'GITLAB_LDAP_USERNAME' => :ldap_username,
          'GITLAB_LDAP_PASSWORD' => :ldap_password,
          'GITLAB_USER_TYPE' => :user_type,
          'GITLAB_SANDBOX_NAME' => :gitlab_sandbox_name,
          'GITLAB_QA_ACCESS_TOKEN' => :qa_access_token,
          'GITHUB_ACCESS_TOKEN' => :github_access_token,
          'GITLAB_URL' => :gitlab_url,
          'EE_LICENSE' => :ee_license,
          'GCLOUD_ACCOUNT_EMAIL' => :gcloud_account_email,
          'GCLOUD_ACCOUNT_KEY' => :gcloud_account_key,
          'CLOUDSDK_CORE_PROJECT' => :cloudsdk_core_project,
          'GCLOUD_ZONE' => :gcloud_zone
        }.freeze

        ENV_VARIABLES.each_value do |accessor|
          send(:attr_accessor, accessor) # rubocop:disable GitlabSecurity/PublicSend
        end

        def run_id
          @run_id ||= "gitlab-qa-run-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}-#{SecureRandom.hex(4)}"
        end

        def qa_access_token
          ENV['GITLAB_QA_ACCESS_TOKEN']
        end

        def dev_access_token_variable
          env_value_if_defined('GITLAB_QA_DEV_ACCESS_TOKEN')
        end

        def host_artifacts_dir
          @host_artifacts_dir ||= File.join(ENV['QA_ARTIFACTS_DIR'] || '/tmp/gitlab-qa', Runtime::Env.run_id)
        end

        def variables
          vars = {}

          ENV_VARIABLES.each do |name, attribute|
            # Variables that are overriden in the environment take precedence
            # over the defaults specified by the QA runtime.
            value = env_value_if_defined(name) || send(attribute) # rubocop:disable GitlabSecurity/PublicSend
            vars[name] = value if value
          end

          vars
        end

        def require_license!
          return if ENV.include?('EE_LICENSE')

          raise ArgumentError, 'GitLab License is not available. Please load a license into EE_LICENSE env variable.'
        end

        def require_no_license!
          return unless ENV.include?('EE_LICENSE')

          raise ArgumentError, "Unexpected EE_LICENSE provided. Please unset it to continue."
        end

        def require_qa_access_token!
          return unless ENV['GITLAB_QA_ACCESS_TOKEN'].to_s.strip.empty?

          raise ArgumentError, "Please provide GITLAB_QA_ACCESS_TOKEN"
        end

        def require_kubernetes_environment!
          %w[GCLOUD_ACCOUNT_EMAIL GCLOUD_ACCOUNT_KEY CLOUDSDK_CORE_PROJECT GCLOUD_ZONE].each do |env_key|
            raise ArgumentError, "Environment variable #{env_key} must be set to run kubernetes specs" unless ENV.key?(env_key)
          end
        end

        private

        def env_value_if_defined(variable)
          # Pass through the variables if they are defined in the environment
          return "$#{variable}" if ENV[variable]
        end
      end
    end
  end
end
