# frozen_string_literal: true

# Type: Model (Database) - Project
class Project < Sequel::Model
  plugin :validation_helpers

  one_to_many :sessions

  def before_create
    self.created_at ||= Time.now
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end

  def validate
    super
    validates_presence :name
    validates_unique :name
  end

  def session_running?
    return sessions.filter { |s| s.end_time.nil? }.count.positive? if sessions.any?

    false
  end

  def status
    ' | in progress' if session_running?
  end
end
