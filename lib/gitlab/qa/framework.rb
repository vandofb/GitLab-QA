lib = File.expand_path('../', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

module Gitlab
  module QA
    module Framework
      module Docker
        autoload :Command, 'qa/framework/docker/command'
        autoload :Engine, 'qa/framework/docker/engine'
        autoload :Shellout, 'qa/framework/docker/shellout'
        autoload :Volumes, 'qa/framework/docker/volumes'
      end

      module Factory
        autoload :Base, 'qa/framework/factory/base'
        autoload :Dependency, 'qa/framework/factory/dependency'
        autoload :Product, 'qa/framework/factory/product'
      end

      module Page
        autoload :Base, 'qa/framework/page/base'
        autoload :Element, 'qa/framework/page/element'
        autoload :Validator, 'qa/framework/page/validator'
        autoload :View, 'qa/framework/page/view'
      end

      module Runtime
        autoload :Scenario, 'qa/framework/runtime/scenario'
      end

      module Scenario
        autoload :Actable, 'qa/framework/scenario/actable'
        autoload :Bootable, 'qa/framework/scenario/bootable'
        autoload :Template, 'qa/framework/scenario/template'
      end
    end
  end
end
