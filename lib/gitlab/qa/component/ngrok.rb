require 'securerandom'
require 'net/http'
require 'uri'
require 'forwardable'
require 'ngrok/tunnel'

module Gitlab
  module QA
    module Component
      class Ngrok
        include Scenario::Actable

        DOCKER_IMAGE = 'dylangriffith/ngrok-v1'.freeze
        DOCKER_IMAGE_TAG = 'latest'.freeze

        attr_writer :gitlab_hostname, :name
        attr_accessor :network

        def initialize
          @docker = Docker::Engine.new
          @volumes = {}

          @ngrok_config = Tempfile.new('ngrok_config')
          @ngrok_config.write("server_addr: #{ngrok_server_hostname}:4443\ntrust_host_root_certs: true")
          @ngrok_config.close
          @volumes[@ngrok_config.path] = '/root/.ngrok'
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          prepare
          start

          yield self

          teardown
        end

        def url
          "https://#{subdomain}.#{ngrok_server_hostname}"
        end

        private

        def name
          @name ||= "ngrok-#{SecureRandom.hex(4)}"
        end

        def prepare
          @docker.pull(DOCKER_IMAGE, DOCKER_IMAGE_TAG)

          return if @docker.network_exists?(network)

          @docker.network_create(network)
        end

        def ngrok_server_hostname
          ENV.fetch("NGROK_SERVER_HOSTNAME")
        end

        def subdomain
          @subdomain ||= SecureRandom.hex(8)
        end

        def start
          raise "Must set gitlab_hostname" unless @gitlab_hostname

          @docker.run(DOCKER_IMAGE, DOCKER_IMAGE_TAG, "-log stdout -subdomain #{subdomain} #{@gitlab_hostname}:80") do |command|
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
