require 'tmpdir'

module Gitlab
  module QA
    module Framework
      module Docker
        class Volumes
          def initialize(volumes)
            @volumes = volumes
          end

          def with_temporary_volumes
            # macOS's tmpdir is a symlink /var/folders -> /private/var/folders
            # but Docker on macOS exposes /private and disallow exposing /var/
            # so we need to get the real tmpdir path
            Dir.mktmpdir('qa-framework-', File.realpath(Dir.tmpdir)).tap do |dir|
              yield Hash[@volumes.map { |k, v| ["#{dir}/#{k}", v] }]
            end
          end
        end
      end
    end
  end
end
