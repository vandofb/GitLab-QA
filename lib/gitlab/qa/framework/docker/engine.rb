module Gitlab
  module QA
    module Framework
      module Docker
        class Engine
          DOCKER_HOST = ENV['DOCKER_HOST'] || 'http://localhost'

          def hostname
            URI(DOCKER_HOST).host
          end

          def pull(image, tag)
            Command.execute("pull #{image}:#{tag}")
          end

          def run(image, tag, *args)
            Command.new('run').tap do |command|
              yield command if block_given?

              command << "#{image}:#{tag}"
              command << args if args.any?

              command.execute!
            end
          end

          def read_file(image, tag, path, &block)
            cat_file = "run --rm --entrypoint /bin/cat #{image}:#{tag} #{path}"
            Command.execute(cat_file, &block)
          end

          def attach(name, &block)
            Command.execute("attach --sig-proxy=false #{name}", &block)
          end

          def restart(name)
            Command.execute("restart #{name}")
          end

          def stop(name)
            Command.execute("stop #{name}")
          end

          def remove(name)
            Command.execute("rm -f #{name}")
          end

          def network_exists?(name)
            Command.execute("network inspect #{name}")
          rescue Shellout::StatusError
            false
          else
            true
          end

          def network_create(name)
            Command.execute("network create #{name}")
          end

          def port(name, port)
            Command.execute("port #{name} #{port}/tcp")
          end
        end
      end
    end
  end
end
