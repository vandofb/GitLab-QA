module Gitlab
  module QA
    module Docker
      class Engine
        DOCKER_HOST = ENV['DOCKER_HOST'] || 'http://localhost'

        def hostname
          URI(DOCKER_HOST).host
        end

        def pull(image, tag)
          Docker::Command.execute("pull #{image}:#{tag}")
        end

        def run(image, tag, *args)
          Docker::Command.new('run').tap do |command|
            yield command

            command << "#{image}:#{tag}"
            command << args if args.any?

            command.execute!
          end
        end

        def attach(name, &block)
          Docker::Command.execute("attach --sig-proxy=false #{name}", &block)
        end

        def stop(name)
          Docker::Command.execute("stop #{name}")
        end

        def remove(name)
          Docker::Command.execute("rm -f #{name}")
        end

        def network_exists?(name)
          Docker::Command.execute("network inspect #{name}")
        rescue Docker::Command::StatusError
          false
        else
          true
        end

        def network_create(name)
          Docker::Command.execute("network create #{name}")
        end
      end
    end
  end
end
