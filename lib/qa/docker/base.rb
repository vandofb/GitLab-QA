module QA
  module Docker
    class Base
      extend Scenario::Actable

      DOCKER_HOST = ENV['DOCKER_HOST'] || 'http://localhost'
    end
  end
end
