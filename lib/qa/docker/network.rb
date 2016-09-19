module QA
  module Docker
    class Network < Docker::Base
      def exists?(name)
        exec("docker network inspect #{name}")
      rescue CommandError
        false
      else
        true
      end

      def create(name)
        exec("docker network create #{name}")
      end
    end
  end
end
