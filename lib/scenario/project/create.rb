module Scenario
  module Project
    class Create < Scenario::Template
      attr_accessor :project_name, :project_description

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
    end
  end
end
