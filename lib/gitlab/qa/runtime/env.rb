module Gitlab
  module QA
    module Runtime
      module Env
        extend self

        VARIABLES = %w(GITLAB_USERNAME GITLAB_PASSWORD
                       GITLAB_URL EE_LICENSE).freeze

        def screenshots_dir
          ENV['QA_SCREENSHOTS_DIR'] || '/tmp/gitlab-qa-screenshots'
        end

        def delegated
          VARIABLES.dup.tap do |variables|
            variables << 'DOCKER_HOST' if dind?
          end
        end

        def dind?
          !ENV['DOCKER_HOST'].to_s.strip.empty?
        end
      end
    end
  end
end
