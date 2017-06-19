module Gitlab
  module QA
    class Release
      CUSTOM_GITLAB_IMAGE_REGEX = /gitlab-([ce]e):(\w+)/
      DEFAULT_TAG = 'nightly'.freeze

      attr_reader :release

      def initialize(release)
        @release = release.to_s
      end

      def edition
        if canonical?
          release.downcase.to_sym
        else
          release.match(CUSTOM_GITLAB_IMAGE_REGEX)[1].to_sym
        end
      end

      def image
        if canonical?
          "gitlab/gitlab-#{edition}"
        else
          release.sub(/:\w+/, '')
        end
      end

      def tag
        if canonical?
          DEFAULT_TAG
        else
          release.match(CUSTOM_GITLAB_IMAGE_REGEX)[2]
        end
      end

      private

      def canonical?
        %w(ce ee).include?(release.downcase)
      end
    end
  end
end
