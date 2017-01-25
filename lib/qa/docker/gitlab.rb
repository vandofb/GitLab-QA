require 'securerandom'
require 'net/http'
require 'uri'

module QA
  module Docker
    class Gitlab
      include Scenario::Actable

      # rubocop:disable Style/Semicolon

      attr_writer :image, :tag, :volumes, :network

      def initialize
        @docker = Docker::Engine.new
      end

      def name=(name)
        @name = "#{name}-#{SecureRandom.hex(4)}"
      end

      def address
        "http://#{@docker.hostname}"
      end

      def instance
        raise 'Please provide a block!' unless block_given?

        prepare; start; reconfigure; wait
        yield address
        teardown
      end

      def prepare
        @docker.pull(@image, @tag)

        return if @docker.network_exists?(@network)
        @docker.network_create(@network)
      end

      def start
        unless [@name, @image, @tag, @network].all?
          raise 'Please configure an instance first!'
        end

        # It is difficult to access docker network from the host
        # due to DNS resolution, so for now we just expose ports.
        #
        @docker.run(@image, @tag) do |command|
          command << "-d --net #{@network} -p 80:80"
          command << "--name #{@name} --hostname #{@docker.hostname}"

          @volumes.to_h.each do |to, from|
            command << "--volume #{to}:#{from}:Z"
          end
        end
      end

      def reconfigure
        @docker.attach(@name) do |line, wait|
          # TODO, workaround which allows to detach from the container
          #
          Process.kill('INT', wait.pid) if line =~ /gitlab Reconfigured!/
        end
      end

      def teardown
        raise 'Invalid instance name!' unless @name

        @docker.stop(@name)
        @docker.remove(@name)
      end

      def wait
        puts "GitLab URL: #{address}"
        print 'Waiting for GitLab to become available '

        if Availability.new(address).check(180)
          sleep 12 # TODO, handle that better
          puts ' -> GitLab is available.'
        else
          abort ' -> GitLab unavailable!'
        end
      end

      class Availability
        def initialize(address)
          @uri = URI.join(address, '/help')
        end

        def check(retries)
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
