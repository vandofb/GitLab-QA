require 'json'
require 'net/http'
require 'cgi'

module Gitlab
  module QA
    module Scenario
      module Test
        module Sanity
          # This test checks that the sha_version of a GitLab was authored in
          # the window defined by `HOURS_AGO`.  We perform a single API call,
          # so `COMMITS` needs to be a large enough value that we expect all
          # the commits in the time window will fit.
          class Version
            include Gitlab::QA::Framework::Scenario::Template

            HOURS_AGO = 24
            COMMITS = 10_000

            def perform(options, release)
              version = Component::Gitlab.perform do |gitlab|
                gitlab.release = release
                gitlab.act do
                  pull
                  sha_version
                end
              end

              project = "gitlab-org/#{Release.new(release).project_name}"
              commit = recent_commits(project).find { |c| c['id'] == version }

              if commit
                puts "Found commit #{version} in recent history of #{project}"
              else
                puts "Did not find #{version} in recent history of #{project}"
                exit 1
              end
            end

            private

            def recent_commits(project)
              api = 'https://gitlab.com/api/v4'
              url = "#{api}/projects/#{CGI.escape(project)}/repository/commits"
              since = (Time.now - HOURS_AGO * 60 * 60).strftime('%FT%T')

              uri = URI(url)
              uri.query = URI.encode_www_form(since: since, per_page: COMMITS)
              JSON.parse(Net::HTTP.get(uri))
            end
          end
        end
      end
    end
  end
end
