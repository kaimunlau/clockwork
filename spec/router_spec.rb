# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../lib/router'
require_relative '../lib/view'
require_relative '../lib/models/project'
require_relative '../lib/models/session'
require_relative '../lib/controllers/projects_controller'
require_relative '../lib/controllers/sessions_controller'

RSpec.describe Router do
  let(:view) { instance_double(View) }
  let(:projects_controller) { instance_double(ProjectsController) }
  let(:sessions_controller) { instance_double(SessionsController) }
  let(:options) { {} }
  let(:router) { Router.new(options, view, projects_controller, sessions_controller) }

  describe '#execute' do
    context 'when no options are provided' do
      it 'displays the welcome message' do
        expect(view).to receive(:welcome)
        router.execute
      end
    end

    context 'when more than one option is provided' do
      let(:options) { { new: true, list: true } }

      it 'displays the too many options message' do
        expect(view).to receive(:too_many_options)
        router.execute
      end
    end

    context 'when the new option is provided' do
      let(:options) { { new: true } }

      it 'creates a new project' do
        expect(view).to receive(:ask_for_input).with('What is the name of your project?').and_return('Project Name')

        # Stubbing the project creation through the projects controller
        allow(projects_controller).to receive(:create).with('Project Name')

        # Stubbing the user's choice to start a session
        expect(view).to receive(:ask_for_option).with('Do you want to start a session for this project?',
                                                      %w[Yes No]).and_return('Yes')

        # Expecting the router to start a session
        expect(router).to receive(:start_session).with('Project Name')

        router.execute
      end
    end

    context 'when the start option is provided' do
      let(:options) { { start: 'Project Name' } }

      it 'starts a session for the specified project' do
        # Stubbing Project.all to return a dummy project
        allow(Project).to receive(:all).and_return([Project.new(name: 'Dummy Project')])

        # Stubbing view method to return the project name
        allow(view).to receive(:ask_for_option).with('Enter the name of the project:',
                                                     ['Project Name']).and_return('Project Name')

        # Stubbing Project.first to return the Project Name
        allow(Project).to receive(:first).with(name: 'Project Name').and_return(Project.new(name: 'Project Name'))

        # Stubbing session creation and saving
        allow(sessions_controller).to receive(:create)

        router.execute
      end
    end

    context 'when the pause option is provided' do
      let(:options) { { pause: true } }

      it 'ends the session for the current project' do
        # Stubbing a session that is currently running
        running_session = instance_double(Session, project: Project.new(name: 'Running Project'), end_time: nil)

        # Stubbing the save method of the session
        allow(running_session).to receive(:save)

        # Stubbing the end_time= method of the session
        allow(running_session).to receive(:end_time=)

        # Stubbing the valid? method of the session to return true
        allow(running_session).to receive(:valid?).and_return(true)

        # Stubbing the find method of Session to return the running session
        allow(Session).to receive(:where).and_return([running_session])

        # Expecting the router to save the session
        expect(running_session).to receive(:save)

        # Expecting the router to update the end time of the session
        expect(running_session).to receive(:end_time=)

        # Expecting a success message to be displayed
        expect(view).to receive(:display_success).with("Session ended for project 'Running Project'")

        router.execute
      end

      it 'displays an error message if no session is running' do
        # Stubbing no session running
        allow(Session).to receive(:where).and_return([])

        # Expecting an error message to be displayed
        expect(view).to receive(:display_error).with('No session is running')

        router.execute
      end
    end

    context 'when the total option is provided' do
      let(:options) { { total: 'Project Name' } }

      it 'displays the total time for the specified project' do
        # Stubbing Project.first to return the specified project
        allow(Project).to receive(:first).with(name: 'Project Name').and_return(Project.new(name: 'Project Name'))

        # Expecting the total time to be displayed
        expect(view).to receive(:total_time).with(Project.new(name: 'Project Name'))

        router.execute
      end
    end

    context 'when the delete option is provided' do
      let(:options) { { delete: true } }

      it 'deletes the specified project' do
        project_name = 'Project to Delete'
        allow(router).to receive(:project_name_from_list).and_return(project_name)
        allow(projects_controller).to receive(:delete).with(project_name)

        router.execute
      end
    end
  end
end
