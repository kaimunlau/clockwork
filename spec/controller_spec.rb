require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../lib/controller'
require_relative '../lib/view'
require_relative '../lib/models/project'

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
        expect(view).to receive(:display_message).with('Enter the name of the project:')
        expect(view).to receive(:ask_for_input).and_return('Project Name')

        project_instance = Project.new(name: 'Project Name')
        allow(Project).to receive(:new).with(name: 'Project Name').and_return(project_instance)

        expect(project_instance).to receive(:save).and_return(true)
        expect(view).to receive(:display_message).with("Project 'Project Name' created successfully")
        controller.execute
      end
    end

    context 'when the project is invalid' do
      let(:options) { { new: true } }

      it 'displays an error message' do
        expect(view).to receive(:display_message).with('Enter the name of the project:')
        expect(view).to receive(:ask_for_input).and_return('Project Name')

        project_instance = Project.new(name: 'Project Name')
        allow(Project).to receive(:new).with(name: 'Project Name').and_return(project_instance)

        allow(project_instance).to receive(:valid?).and_return(false)
        allow(project_instance).to receive_message_chain(:errors, :full_messages).and_return(['Error Message'])

        expect(view).to receive(:display_error).with("Could not create project 'Project Name': Error Message")
        controller.execute
      end
    end
  end
end
