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

    def with_username(name)
      @username = name
    end

    def with_password(pass)
      @password = pass
    end

    def with_location(uri)
      @location = uri
    end

    def clone_over_https
      uri = URI(@location)
      uri.user = @username
      uri.password = @password

      puts uri.to_s
      `git clone #{uri.to_s}`
    end
  end
end
