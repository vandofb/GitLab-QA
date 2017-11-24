require 'tmpdir'

module Gitlab
  module QA
    module Scenario
      module WithTempVolumes
        VOLUMES = { 'config' => '/etc/gitlab',
                    'logs' => '/var/log/gitlab',
                    'data' => '/var/opt/gitlab' }.freeze

        def with_temporary_volumes
          # macOS's tmpdir is a symlink /var/folders -> /private/var/folders
          # but Docker on macOS exposes /private and disallow exposing /var/
          # so we need to get the real tmpdir path
          Dir.mktmpdir('gitlab-qa-', File.realpath(Dir.tmpdir)).tap do |dir|
            yield Hash[VOLUMES.map { |k, v| ["#{dir}/#{k}", v] }]
          end
        end
      end
    end
  end
end
