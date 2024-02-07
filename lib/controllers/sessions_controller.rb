# frozen_string_literal: true

# This class is responsible for managing the logic sessions
class SessionsController
  def initialize(view)
    @view = view
  end

  def create(project)
    session = Session.new(project_id: project.id, start_time: Time.now)
    save_session(session, 'start')
  end

  private

  def save_session(session, verb)
    if session.valid?
      session.save
      @view.display_success("Session #{verb}ed for project '#{session.project.name}'")
    else
      @view.display_error("Could not #{verb} session for project '#{session.project.name}': #{session.errors.full_messages.join(', ')}")
    end
  end
end
