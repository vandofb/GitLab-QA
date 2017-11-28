module Gitlab
  module QA
    module Runtime
      module Env
        extend self

        VARIABLES = %w[GITLAB_USERNAME
                       GITLAB_PASSWORD
                       GITLAB_URL
                       EE_LICENSE].freeze

        def screenshots_dir
          ENV['QA_SCREENSHOTS_DIR'] || '/tmp/gitlab-qa/screenshots'
        end

        def logs_dir
          ENV['QA_LOGS_DIR'] || '/tmp/gitlab-qa/logs'
        end

        def delegated
          VARIABLES.select { |name| ENV[name] }
        end
      end
    end
  end
end
