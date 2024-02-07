# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../lib/router'
require_relative '../lib/view'
require_relative '../lib/models/project'
require_relative '../lib/models/session'

RSpec.describe Router do
  let(:view) { instance_double(View) }
  let(:options) { {} }
  let(:router) { Router.new(options, view) }

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

        project_instance = Project.new(name: 'Project Name')
        allow(Project).to receive(:new).with(name: 'Project Name').and_return(project_instance)
        allow(project_instance).to receive(:save).and_return(true)

        expect(view).to receive(:ask_for_option).with('Do you want to start a session for this project?',
                                                      %w[Yes No]).and_return('Yes')

        expect(router).to receive(:start_session).with('Project Name')

        expect(view).to receive(:display_success).with("Project 'Project Name' created successfully")

        router.execute
      end
    end

    context 'when the project is invalid' do
      let(:options) { { new: true } }

      it 'displays an error message' do
        expect(view).to receive(:ask_for_input).with('What is the name of your project?').and_return('Project Name')

        project_instance = Project.new(name: 'Project Name')
        allow(Project).to receive(:new).with(name: 'Project Name').and_return(project_instance)

        allow(project_instance).to receive(:valid?).and_return(false)

        allow(project_instance.errors).to receive(:full_messages).and_return(['Error Message'])

        expect(view).to receive(:display_error).with("Could not create project 'Project Name': Error Message")

        expect(view).to receive(:ask_for_option).with('Do you want to start a session for this project?',
                                                      %w[Yes No]).and_return('No')

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
        session = instance_double(Session, valid?: true, save: true, project: Project.new(name: 'Project Name'))
        allow(Session).to receive(:new).and_return(session)

        expect(view).to receive(:display_success).with("Session started for project 'Project Name'")

        router.execute
      end
    end

    context 'when the list option is provided' do
      let(:options) { { list: true } }

      it 'lists all the projects' do
        # Stubbing Project.all to return a dummy project
        allow(Project).to receive(:all).and_return([Project.new(name: 'Dummy Project')])

        expect(view).to receive(:display_projects).with([Project.new(name: 'Dummy Project')])

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

        # Stubbing the project deletion confirmation
        allow(view).to receive(:ask_for_option).with("Are you sure you want to delete project '#{project_name}'?",
                                                     %w[No Yes]).and_return('Yes')

        # Stubbing the project retrieval
        project = instance_double(Project, sessions: [], destroy: true)
        allow(Project).to receive(:first).with(name: project_name).and_return(project)

        # Stubbing project_name_from_list to return the specified project name
        allow(router).to receive(:project_name_from_list).and_return(project_name)

        # Expecting the project and its sessions to be deleted
        expect(project).to receive(:sessions).and_return([])
        expect(project).to receive(:destroy)

        # Expecting a success message to be displayed
        expect(view).to receive(:display_success).with("Project '#{project_name}' deleted successfully")

        router.execute
      end
    end
  end
end
