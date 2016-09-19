require 'uri'

module QA
  module Git
    class Repository
      include ::RSpec::Matchers

      def self.act(*variables, &block)
        new.tap do |repository|
          Dir.mktmpdir do |dir|
            Dir.chdir(dir) do
              repository.instance_exec(*variables, &block)
            end
          end
        end
      end

      def with_location(uri)
        @location = uri
        @uri = URI(uri)
      end

      def with_username(name)
        @username = name
        @uri.user = name
      end

      def with_password(pass)
        @password = pass
        @uri.password = pass
      end

      def with_default_credentials
        with_username(Run::User.name)
        with_password(Run::User.password)
      end

      def clone_repository(opts = '')
        `git clone #{opts} #{@uri.to_s} ./`
      end

      def clone_repository_shallow
        clone_repository('--depth 1')
      end

      def configure_identity(name, email)
        `git config user.name #{name}`
        `git config user.email #{email}`
      end

      def commit_file(name, contents, message)
        add_file(name, contents)
        commit(message)
      end

      def add_file(name, contents)
        File.write(name, contents)

        `git add #{name}`
      end

      def commit(message)
        `git commit -m "#{message}"`
      end

      def push_changes(branch = 'master')
        `git push #{@uri.to_s} #{branch}`
      end

      def commits
        `git log --oneline`.split("\n")
      end
    end
  end
end
