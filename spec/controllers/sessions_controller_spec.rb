# frozen_string_literal: true

require 'rspec'
require 'sequel'
DB = Sequel.sqlite('db/database.db')
require_relative '../../lib/models/project'
require_relative '../../lib/models/session'
require_relative '../../lib/controllers/sessions_controller'
require_relative '../../lib/view'

RSpec.describe SessionsController do
  let(:view) { instance_double(View) }
  let(:sessions_controller) { SessionsController.new(view) }

  describe '#create' do
    let(:project) { instance_double(Project, id: 1, name: 'Project Name') }
    let(:session) { instance_double(Session, project: project) }

    it 'creates a new session' do
      # Stubbing Time.now to return a fixed time
      allow(Time).to receive(:now).and_return(Time.utc(2024, 2, 7, 15, 49, 19, 0))

      # Stubbing Session.new with the expected arguments
      expect(Session).to receive(:new).with(project_id: 1,
                                            start_time: Time.utc(2024, 2,
                                                                 7, 15, 49, 19, 0)).and_return(session)

      # Stubbing session validity and saving
      allow(session).to receive(:valid?).and_return(true)
      expect(session).to receive(:save)

      # Expecting the success message to be displayed
      expect(view).to receive(:display_success).with("Session started for project 'Project Name'")

      # Calling the method under test
      sessions_controller.create(project)
    end
  end
end
