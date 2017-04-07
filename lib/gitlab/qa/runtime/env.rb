module Gitlab
  module QA
    module Runtime
      module Env
        extend self

        def screenshots_dir
          ENV['QA_SCREENSHOTS_DIR'] || '/tmp/gitlab-qa-screenshots'
        end

        def delegated
          %w(GITLAB_USERNAME GITLAB_PASSWORD GITLAB_URL EE_LICENSE).freeze
        end
      end
    end
  end
end
