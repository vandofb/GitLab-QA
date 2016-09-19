module QA
  module Docker
    class Network < Docker::Base
      def exists?(name)
        exec "docker network inspect #{name}"
      rescue
        false
      else
        true
      end

      def create(name)
      end
    end
  end
end
