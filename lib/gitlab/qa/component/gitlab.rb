require 'securerandom'
require 'net/http'
require 'uri'
require 'forwardable'

module Gitlab
  module QA
    module Component
      class Gitlab
        extend Forwardable
        include Scenario::Actable

        attr_reader :release, :docker, :port
        attr_accessor :volumes, :network, :environment
        attr_writer :name

        def_delegators :release, :tag, :image, :edition

        def initialize
          @docker = Docker::Engine.new
          @environment = {}
          @volumes = {}
          @network_aliases = []
          @port = rand(10_000) + 30_000

          self.release = 'CE'
        end

        def omnibus_config=(config)
          @environment['GITLAB_OMNIBUS_CONFIG'] = config.tr("\n", ' ')
        end

        def add_network_alias(name)
          @network_aliases.push(name)
        end

        def release=(release)
          @release = Release.new(release)
        end

        def name
          @name ||= "gitlab-qa-#{edition}-#{SecureRandom.hex(4)}"
        end

        def address
          "http://#{hostname}"
        end

        def hostname
          "#{name}.#{network}"
        end

        def instance
          raise 'Please provide a block!' unless block_given?

          prepare
          start
          reconfigure
          wait

          yield self

          teardown
        end

        def prepare
          @docker.pull(image, tag)

          return if @docker.network_exists?(network)

          @docker.network_create(network)
        end

        def start # rubocop:disable Metrics/AbcSize
          ensure_configured!

          docker.run(image, tag) do |command|
            puts "*********************************** random_port=#{@port}"
            command << '-d'
            command << "-p #{@port}:80"
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"

            @volumes.to_h.each do |to, from|
              command.volume(to, from, 'Z')
            end

            File.join(Runtime::Env.logs_dir, name).tap do |logs_dir|
              command.volume(logs_dir, '/var/log/gitlab', 'Z')
            end

            @environment.to_h.each do |key, value|
              command.env(key, value)
            end

            @network_aliases.to_a.each do |network_alias|
              command << "--network-alias #{network_alias}"
            end
          end
        end

        def reconfigure
          @docker.attach(name) do |line, wait|
            puts line
            # TODO, workaround which allows to detach from the container
            #
            Process.kill('INT', wait.pid) if line =~ /gitlab Reconfigured!/
          end
        end

        def restart
          @docker.restart(name)
        end

        def teardown
          raise 'Invalid instance name!' unless name

          @docker.stop(name)
          @docker.remove(name)
        end

        def wait
          if Availability.new(name).check(180)
            sleep 12 # TODO, handle that better
            puts ' -> GitLab is available.'
          else
            abort ' -> GitLab unavailable!'
          end
        end

        def pull
          @docker.pull(@release.image, @release.tag)
        end

        def sha_version
          json = @docker.read_file(
            @release.image, @release.tag,
            '/opt/gitlab/version-manifest.json'
          )

          manifest = JSON.parse(json)
          manifest['software']['gitlab-rails']['locked_version']
        end

        private

        def ensure_configured!
          raise 'Please configure an instance first!' unless [name, release, network].all?
        end

        class Availability
          def initialize(name)
            @docker = Docker::Engine.new

            host = @docker.hostname
            port = @docker.port(name, 80).split(':').last

            @uri = URI.join("http://#{host}:#{port}", '/help')
          end

          def check(retries)
            print "Waiting for GitLab at `#{@uri}` to become available "

            retries.times do
              return true if service_available?

              print '.'
              sleep 1
            end

            false
          end

          private

          def service_available?
            response = Net::HTTP.start(@uri.host, @uri.port) do |http|
              http.head2(@uri.request_uri)
            end

            response.code.to_i == 200
          rescue Errno::ECONNREFUSED, Errno::ECONNRESET, EOFError
            false
          end
        end
      end
    end
  end
end
