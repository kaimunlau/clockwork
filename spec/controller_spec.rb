# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../lib/controller'
require_relative '../lib/view'
require_relative '../lib/models/project'
require_relative '../lib/models/session'

RSpec.describe Controller do
  let(:view) { instance_double(View) }
  let(:options) { {} }
  let(:controller) { Controller.new(options, view) }

  describe '#execute' do
    context 'when no options are provided' do
      it 'displays the welcome message' do
        expect(view).to receive(:welcome)
        controller.execute
      end
    end

    context 'when more than one option is provided' do
      let(:options) { { new: true, list: true } }

      it 'displays the too many options message' do
        expect(view).to receive(:too_many_options)
        controller.execute
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

        expect(controller).to receive(:start_session).with('Project Name')

        expect(view).to receive(:display_success).with("Project 'Project Name' created successfully")

        controller.execute
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

        controller.execute
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

        controller.execute
      end
    end
  end
end
