module Gitlab
  module QA
    class Release
      CUSTOM_GITLAB_IMAGE_REGEX = %r{/gitlab-([ce]e):(.+)\z}
      DEFAULT_TAG = 'nightly'.freeze

      attr_reader :release
      attr_writer :tag

      def initialize(release)
        @release = release.to_s
      end

      def to_s
        "#{image}:#{tag}"
      end

      def previous_stable
        # The previous stable is always gitlab/gitlab-ce:latest or
        # gitlab/gitlab-ee:latest
        self.class.new("#{canonical_image}:latest")
      end

      def edition
        @edition ||=
          if canonical?
            release.downcase.to_sym
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[1].to_sym
          end
      end

      def image
        @image ||=
          if canonical?
            "gitlab/gitlab-#{edition}"
          else
            release.sub(/:.+\z/, '')
          end
      end

      def canonical_image
        @canonical_image ||= "gitlab/gitlab-#{edition}"
      end

      def project_name
        @project_name ||= image.sub(%r{^gitlab\/}, '')
      end

      def tag
        @tag ||=
          if canonical?
            DEFAULT_TAG
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[2]
          end
      end

      def edition_tag
        @edition_tag ||= "#{edition}-#{tag}"
      end

      private

      def canonical?
        %w[ce ee].include?(release.downcase)
      end
    end
  end
end
