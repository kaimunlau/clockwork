# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../../lib/models/project'
require_relative '../../lib/controllers/projects_controller'
require_relative '../../lib/view'

RSpec.describe ProjectsController do
  let(:view) { instance_double(View) }
  let(:projects_controller) { ProjectsController.new(view) }

  describe '#index' do
    context 'when there are no projects' do
      it 'displays a message' do
        allow(Project).to receive(:all).and_return([])
        expect(view).to receive(:no_projects)
        projects_controller.index
      end
    end

    context 'when there are projects' do
      it 'displays the projects' do
        allow(Project).to receive(:all).and_return([Project.new(name: 'Project 1'), Project.new(name: 'Project 2')])
        expect(view).to receive(:display_projects).with([Project.new(name: 'Project 1'),
                                                         Project.new(name: 'Project 2')])
        projects_controller.index
      end
    end
  end

  describe '#create' do
    context 'when the project is valid' do
      it 'creates the project' do
        project = Project.new(name: 'Project Name')
        expect(Project).to receive(:new).with(name: 'Project Name').and_return(project)
        expect(project).to receive(:valid?).and_return(true)
        expect(project).to receive(:save)
        expect(view).to receive(:display_success).with("Project 'Project Name' created successfully")
        projects_controller.create('Project Name')
      end
    end
  end

  describe '#delete' do
    context 'when the user confirms the deletion' do
      it 'deletes the project' do
        project = Project.new(name: 'Project Name')
        allow(Project).to receive(:first).with(name: 'Project Name').and_return(project)
        expect(view).to receive(:ask_for_option).with("Are you sure you want to delete project 'Project Name'?",
                                                      %w[No Yes]).and_return('Yes')
        expect(project).to receive(:sessions).and_return([])
        expect(project).to receive(:destroy)
        expect(view).to receive(:display_success).with("Project 'Project Name' deleted successfully")
        projects_controller.delete('Project Name')
      end
    end
  end
end
