$LOAD_PATH.unshift(File.expand_path('../', __dir__)).uniq!

module Gitlab
  module QA
    module Framework
      module Docker
        autoload :Command, 'qa/framework/docker/command'
        autoload :Engine, 'qa/framework/docker/engine'
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
        autoload :Address, 'qa/framework/runtime/address'
        autoload :Browser, 'qa/framework/runtime/browser'
        autoload :Env, 'qa/framework/runtime/env'
        autoload :Scenario, 'qa/framework/runtime/scenario'
        autoload :Session, 'qa/framework/runtime/session'
      end

      module Scenario
        autoload :Actable, 'qa/framework/scenario/actable'
        autoload :Bootable, 'qa/framework/scenario/bootable'
        autoload :Runner, 'qa/framework/scenario/runner'
        autoload :Taggable, 'qa/framework/scenario/taggable'
        autoload :Template, 'qa/framework/scenario/template'
      end

      module Utils
        autoload :Shellout, 'qa/framework/utils/shellout'
      end
    end
  end
end
