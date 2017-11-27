module Gitlab
  module QA
    class Release
      CANONICAL_REGEX = /\A(?<edition>ce|ee):?(?<tag>.+)?/i
      CUSTOM_GITLAB_IMAGE_REGEX = %r{/gitlab-(?<edition>[ce]e):(?<tag>.+)\z}
      DEFAULT_TAG = 'nightly'.freeze

      attr_reader :release
      attr_writer :tag

      def initialize(release)
        @release = release.to_s.downcase
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
            release.match(CANONICAL_REGEX)[:edition].to_sym
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[:edition].to_sym
          end
      end

      def ee?
        edition == :ee
      end

      def to_ee
        return self if ee?

        self.class.new(to_s.sub('ce:', 'ee:'))
      end

      def image
        @image ||=
          if canonical?
            "gitlab/gitlab-#{edition}"
          else
            release.sub(/:.+\z/, '')
          end
      end

      def project_name
        @project_name ||= image.sub(%r{^gitlab\/}, '')
      end

      def tag
        @tag ||=
          if canonical?
            release.match(CANONICAL_REGEX)[:tag] || DEFAULT_TAG
          else
            release.match(CUSTOM_GITLAB_IMAGE_REGEX)[:tag]
          end
      end

      def edition_tag
        @edition_tag ||= "#{edition}-#{tag}"
      end

      private

      def canonical?
        release =~ CANONICAL_REGEX
      end

      def canonical_image
        @canonical_image ||= "gitlab/gitlab-#{edition}"
      end
    end
  end
end
