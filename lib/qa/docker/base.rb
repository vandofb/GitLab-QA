module QA
  module Docker
    class Base
      include Scenario::Actable

      DOCKER_HOST = ENV['DOCKER_HOST'] || 'http://localhost'
    end
  end
end
