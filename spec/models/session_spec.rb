# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../../lib/models/project'
require_relative '../../lib/models/session'

RSpec.describe Session do
  describe 'validations' do
    it 'is valid with a project_id' do
      project = Project.create(name: 'Sample Project')
      session = Session.new(project_id: project.id)
      expect(session).to be_valid
      project.delete
    end

    it 'is invalid without a project_id' do
      session = Session.new
      session.valid?
      expect(session.errors[:project_id]).to include('is not present')
    end
  end
end
