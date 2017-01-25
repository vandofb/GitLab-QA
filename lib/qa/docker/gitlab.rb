require 'securerandom'
require 'net/http'
require 'uri'

module QA
  module Docker
    class Gitlab < Docker::Base
      attr_writer :image, :tag, :volumes, :network

      def name=(name)
        @name = "#{name}-#{SecureRandom.hex(4)}"
      end

      def hostname
        # It is difficult to access docker network from the host
        # due to DNS resolution, so for now we just expose ports.

        URI(DOCKER_HOST).host
      end

      def address
        "http://#{hostname}"
      end

      def instance
        raise 'Please provide a block!' unless block_given?

        pull
        start
        reconfigure
        wait

        yield address

        teardown
      end

      def pull
        Docker::Command.execute("pull #{@image}:#{@tag}")
      end

      def start # rubocop:disable Metrics/MethodLength
        unless [@name, @image, @tag, @network].all?
          raise 'Please configure an instance first!'
        end

        command = Docker::Command.new('run') \
          << "-d --net #{@network} -p 80:80" \
          << "--name #{@name} --hostname #{hostname}"

        @volumes.to_h.each do |to, from|
          command << "--volume #{to}:#{from}:Z"
        end

        command << "#{@image}:#{@tag}"
        command.execute!
      end

      def attach(&block)
        Docker::Command.execute("attach --sig-proxy=false #{@name}", &block)
      end

      def reconfigure
        attach do |line, wait|
          # TODO, this is a workaround, allows to detach from container
          #
          Process.kill('INT', wait.pid) if line =~ /gitlab Reconfigured!/
        end
      end

      def teardown
        raise 'Invalid instance name!' unless @name

        Docker::Command.execute("stop #{@name}")
        Docker::Command.execute("rm -f #{@name}")
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
