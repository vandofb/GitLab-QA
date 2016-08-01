require 'colorize'
require 'net/http'
require 'uri'

class GitLabChecker
  def initialize(url)
    @uri = URI(url)
  end

  def check(retries)
    retries = 2 if retries < 2
    check_loop(retries) do
      return true
    end
    false
  end

  private

  def check_loop(retries)
    Range.new(0, retries - 1).each do
      print '.'
      yield if do_check
      sleep 1
    end
  end

  def do_check
    response = Net::HTTP.start(@uri.host, @uri.port) do |http|
      http.head2(@uri.request_uri)
    end

    response.code.to_i < 500
  rescue Errno::ECONNREFUSED
    false
  end
end

puts "GITLAB_URL: #{ENV['GITLAB_URL']}".cyan
print 'Waiting for GitLab to become available'.bold

if GitLabChecker.new(ENV['GITLAB_URL']).check(60) == true
  puts ' OK'.green.bold
else
  puts ' FAILED'.red.bold
end