require 'securerandom'

module QA
  module Scenario
    module Project
      class Create < Scenario::Template
        attr_reader :project_name, :project_description

        def perform
          Page::Main::Menu.act { go_to_groups }
          Page::Main::Groups.act { prepare_test_namespace }
          Page::Main::Menu.act { go_to_projects }
          Page::Main::Projects.act { go_to_new_project }

          Page::Project::New.act(scenario: self) do
            choose_test_namespace
            choose_name(@scenario.project_name)
            add_description(@scenario.project_description)
            create_new_project
          end
        end

        def with_random_project_name
          @project_name = "test-project-#{SecureRandom.hex(8)}"
        end

        def with_project_name(name)
          @project_name = name
        end

        def with_project_description(description)
          @project_description = description
        end
      end
    end
  end
end
