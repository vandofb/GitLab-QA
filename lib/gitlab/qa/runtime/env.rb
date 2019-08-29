require 'securerandom'

module Gitlab
  module QA
    module Runtime
      module Env
        extend self

        ENV_VARIABLES = {
          'QA_REMOTE_GRID' => :remote_grid,
          'QA_REMOTE_GRID_USERNAME' => :remote_grid_username,
          'QA_REMOTE_GRID_ACCESS_KEY' => :remote_grid_access_key,
          'QA_REMOTE_GRID_PROTOCOL' => :remote_grid_protocol,
          'QA_BROWSER' => :browser,
          'GITLAB_ADMIN_USERNAME' => :admin_username,
          'GITLAB_ADMIN_PASSWORD' => :admin_password,
          'GITLAB_USERNAME' => :user_username,
          'GITLAB_PASSWORD' => :user_password,
          'GITLAB_LDAP_USERNAME' => :ldap_username,
          'GITLAB_LDAP_PASSWORD' => :ldap_password,
          'GITLAB_FORKER_USERNAME' => :forker_username,
          'GITLAB_FORKER_PASSWORD' => :forker_password,
          'GITLAB_USER_TYPE' => :user_type,
          'GITLAB_SANDBOX_NAME' => :gitlab_sandbox_name,
          'GITLAB_QA_ACCESS_TOKEN' => :qa_access_token,
          'GITLAB_QA_ADMIN_ACCESS_TOKEN' => :qa_admin_access_token,
          'GITHUB_ACCESS_TOKEN' => :github_access_token,
          'GITLAB_URL' => :gitlab_url,
          'SIMPLE_SAML_HOSTNAME' => :simple_saml_hostname,
          'ACCEPT_INSECURE_CERTS' => :accept_insecure_certs,
          'EE_LICENSE' => :ee_license,
          'GCLOUD_ACCOUNT_EMAIL' => :gcloud_account_email,
          'GCLOUD_ACCOUNT_KEY' => :gcloud_account_key,
          'CLOUDSDK_CORE_PROJECT' => :cloudsdk_core_project,
          'GCLOUD_REGION' => :gcloud_region,
          'SIGNUP_DISABLED' => :signup_disabled,
          'QA_COOKIES' => :qa_cookie,
          'QA_DEBUG' => :qa_debug,
          'QA_LOG_PATH' => :qa_log_path,
          'QA_CAN_TEST_GIT_PROTOCOL_V2' => :qa_can_test_git_protocol_v2,
          'GITLAB_QA_USERNAME_1' => :gitlab_qa_username_1,
          'GITLAB_QA_PASSWORD_1' => :gitlab_qa_password_1,
          'GITLAB_QA_USERNAME_2' => :gitlab_qa_username_2,
          'GITLAB_QA_PASSWORD_2' => :gitlab_qa_password_2,
          'GITHUB_OAUTH_APP_ID' => :github_oauth_app_id,
          'GITHUB_OAUTH_APP_SECRET' => :github_oauth_app_secret,
          'GITHUB_USERNAME' => :github_username,
          'GITHUB_PASSWORD' => :github_password,
          'KNAPSACK_GENERATE_REPORT' => :knapsack_generate_report,
          'KNAPSACK_REPORT_PATH' => :knapsack_report_path,
          'KNAPSACK_TEST_FILE_PATTERN' => :knapsack_test_file_pattern,
          'KNAPSACK_TEST_DIR' => :knapsack_test_dir,
          'CI' => :ci,
          'CI_NODE_INDEX' => :ci_node_index,
          'CI_NODE_TOTAL' => :ci_node_total,
          'GITLAB_CI' => :gitlab_ci,
          'QA_SKIP_PULL' => :qa_skip_pull,
          'ELASTIC_URL' => :elastic_url
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

        def qa_dev_access_token
          ENV['GITLAB_QA_DEV_ACCESS_TOKEN']
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

        def require_qa_dev_access_token!
          return unless ENV['GITLAB_QA_DEV_ACCESS_TOKEN'].to_s.strip.empty?

          raise ArgumentError, "Please provide GITLAB_QA_DEV_ACCESS_TOKEN"
        end

        def require_oauth_environment!
          %w[GITHUB_OAUTH_APP_ID GITHUB_OAUTH_APP_SECRET GITHUB_USERNAME GITHUB_PASSWORD].each do |env_key|
            raise ArgumentError, "Environment variable #{env_key} must be set to run OAuth specs" unless ENV.key?(env_key)
          end
        end

        def require_kubernetes_environment!
          %w[GCLOUD_ACCOUNT_EMAIL GCLOUD_ACCOUNT_KEY CLOUDSDK_CORE_PROJECT GCLOUD_REGION].each do |env_key|
            raise ArgumentError, "Environment variable #{env_key} must be set to run kubernetes specs" unless ENV.key?(env_key)
          end
        end

        def skip_pull?
          (ENV['QA_SKIP_PULL'] =~ /^(false|no|0)$/i) != 0
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
