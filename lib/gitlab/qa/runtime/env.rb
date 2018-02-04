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
          'GITLAB_URL' => :gitlab_url,
          'EE_LICENSE' => :ee_license
        }.freeze

        ENV_VARIABLES.each_value do |accessor|
          send(:attr_accessor, accessor) # rubocop:disable GitlabSecurity/PublicSend
        end

        def screenshots_dir
          ENV['QA_SCREENSHOTS_DIR'] || '/tmp/gitlab-qa/screenshots'
        end

        def logs_dir
          ENV['QA_LOGS_DIR'] || '/tmp/gitlab-qa/logs'
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

        private

        def env_value_if_defined(variable)
          # Pass through the variables if they are defined in the environment
          return "$#{variable}" if ENV[variable]
        end
      end
    end
  end
end
