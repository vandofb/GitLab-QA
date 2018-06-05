require 'tempfile'

module Gitlab
  module QA
    module Component
      class Ngrok
        include Scenario::Actable

        DOCKER_IMAGE = 'dylangriffith/ssh'.freeze
        DOCKER_IMAGE_TAG = 'latest'.freeze

        attr_writer :gitlab_hostname, :name
        attr_accessor :network

        def initialize
          @docker = Docker::Engine.new
          @volumes = {}

          @ngrok_config = Tempfile.new('tunnel-ssh-private-key')
          @ngrok_config.write(ENV.fetch("TUNNEL_SSH_PRIVATE_KEY"))
          @ngrok_config.close
          @volumes[@ngrok_config.path] = '/root/.ssh/id_rsa'
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          prepare
          start

          yield self

          teardown
        end

        def url
          "https://#{subdomain}.#{tunnel_server_hostname}"
        end

        private

        def name
          @name ||= "ssh-tunnel-#{SecureRandom.hex(4)}"
        end

        def prepare
          @docker.pull(DOCKER_IMAGE, DOCKER_IMAGE_TAG)

          return if @docker.network_exists?(network)

          @docker.network_create(network)
        end

        def tunnel_server_hostname
          ENV.fetch("TUNNEL_SERVER_HOSTNAME")
        end

        def subdomain
          @subdomain ||= 20_000 + rand(10_000)
        end

        def start
          raise "Must set gitlab_hostname" unless @gitlab_hostname

          @docker.run(DOCKER_IMAGE, DOCKER_IMAGE_TAG, "-o StrictHostKeyChecking=no -N -R #{subdomain}:#{@gitlab_hostname}:80 #{ENV.fetch("TUNNEL_SSH_USER")}@#{tunnel_server_hostname}") do |command|
            command << '-d '
            command << "--name #{name}"
            command << "--net #{network}"

            @volumes.to_h.each do |to, from|
              command.volume(to, from, 'Z')
            end
          end
        end

        def restart
          @docker.restart(name)
        end

        def teardown
          raise 'Invalid instance name!' unless name

          @docker.stop(name)
          @docker.remove(name)
          @ngrok_config.unlink
        end
      end
    end
  end
end
