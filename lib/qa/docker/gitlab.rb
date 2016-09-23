require 'securerandom'
require 'net/http'
require 'uri'

module QA
  module Docker
    class Gitlab < Docker::Base
      def with_name(name)
        @name = "#{name}-#{SecureRandom.hex(4)}"
      end

      def with_image(image)
        @image = image
      end

      def with_image_tag(tag)
        @tag = tag
      end

      def within_network(network)
        @network = network
      end

      def hostname
        # It is difficult to access docker network from the host
        # due to DNS resolution, so for now we just expose ports.

        URI(DOCKER_HOST).host
      end

      def url
        "http://#{hostname}"
      end

      def instance
        raise 'Please provide a block!' unless block_given?

        pull
        start
        wait

        yield url

        teardown
      end

      def attach
        exec("docker attach #{@name}") do |line|
          yield line
        end
      end

      def reconfigure
        start
        attach { |line| yield line }
      end

      def pull
        exec("docker pull #{@image}:#{@tag}")
      end

      def start
        unless [@name, @image, @tag, @network].all?
          raise 'Please configure an instance first!'
        end

        command = Docker::Command.new('run') \
          << "-d --net #{@network} -p 80:80" \
          << "--name #{@name} --hostname #{hostname}" \
          << "#{@image}:#{@tag}"

        command.execute!
      end

      def teardown
        raise 'Invalid instance name!' unless @name

        Docker::Command.execute("stop #{@name}")
        Docker::Command.execute("rm #{@name}")
      end

      def wait
        puts "GitLab URL: #{url}"
        print 'Waiting for GitLab to become available '

        if Availability.new(url).check(180)
          sleep 10
          puts ' -> GitLab is available.'
        else
          abort ' -> GitLab unavailable!'
        end
      end

      class Availability
        def initialize(url)
          @uri = URI.join(url, '/help')
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
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET
          false
        end
      end
    end
  end
end
