module Gitlab
  module QA
    module Scenario
      module Test
        module Instance
          ##
          # Run test suite against any GitLab instance,
          # including staging and on-premises installation.
          #
          class Any < Scenario::Template
            def perform(edition, tag, address, *rspec_args)
              release = Release.new(edition).tap do |r|
                r.tag = tag
              end

              Component::Specs.perform do |specs|
                specs.suite = 'Test::Instance'
                specs.release = release
                specs.args = [address, *rspec_args]
              end
            end
          end
        end
      end
    end
  end
end
