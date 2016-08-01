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

puts "GITLAB_URL: #{ENV['GITLAB_URL']}"
print 'Waiting for GitLab to become available'

if GitLabChecker.new(ENV['GITLAB_URL']).check(3) == true
  puts '    [  OK  ]'
else
  puts '    [FAILED]'
  abort "GitLab Service at #{ENV['GITLAB_URL']} is unavailable"
end
