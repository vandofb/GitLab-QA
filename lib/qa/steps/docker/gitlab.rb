module Docker
  class Gitlab < Docker::Base
    def start_instance(_type, _tag = :nightly)
      exec('')
    end
  end
end
