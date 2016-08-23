require 'uri'

module Git
  class Repository
    def self.act(**variables, &block)
      new.tap do |repository|
        variables.each do |variable, value|
          repository.instance_variable_set("@#{variable}", value)
        end

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            repository.instance_eval(&block)
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

    def clone_repository
      `git clone #{@uri.to_s} ./`
    end

    def configure_identity(name, email)
      `git config user.name #{name}`
      `git config user.email #{email}`
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
  end
end
