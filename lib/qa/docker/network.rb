module QA
  module Docker
    class Network < Docker::Base
      def exists?(name)
        Docker::Command.execute("network inspect #{name}")
      rescue Docker::Command::StatusError
        false
      else
        true
      end

      def create(name)
        Docker::Command.execute("network create #{name}")
      end
    end
  end
end