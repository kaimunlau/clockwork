# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../../lib/models/project'

RSpec.describe Project do
  describe 'validations' do
    it 'is valid with a name' do
      project = Project.new(name: 'Sample Project')
      expect(project).to be_valid
    end

    it 'is invalid without a name' do
      project = Project.new
      project.valid?
      expect(project.errors[:name]).to include('is not present')
    end

    it 'is invalid with a duplicate name' do
      Project.create(name: 'Existing Project')
      new_project = Project.new(name: 'Existing Project')
      new_project.valid?
      expect(new_project.errors[:name]).to include('is already taken')
      Project.where(name: 'Existing Project').delete
    end
  end
end
