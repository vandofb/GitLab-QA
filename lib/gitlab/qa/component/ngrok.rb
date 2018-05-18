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

        attr_writer :port

        attr_reader :url

        def instance
          raise 'Please provide a block!' unless block_given?

          start

          yield self

          stop
        end

        private

        def start
          raise "Must set port" unless @port

          @log_file = Tempfile.new('localtunnel')
          @pid = spawn("exec lt --port #{@port} > #{@log_file.path}")
          at_exit { stop }
          load_url
          #ensure_running
        end

        def stop
          Process.kill(9, @pid)
        end

        def load_url
          10.times do
            content = @log_file.read
            match = content.match(/your url is: (?<url>.+)$/)
            if match
              @url = match['url']
              return
            end

            sleep 1
            @log_file.rewind
          end
          raise "Url not found in localtunnel output: #{@log_file.read}"
        end

        def ensure_running
          sleep 10
          Process.getpgid(@pid)
          true
        rescue Errno::ESRCH
          raise "Something went wrong with localtunnel"
        end
      end
    end
  end
end
