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

  def total_time
    total_time = 0
    sessions.each do |session|
      end_time = session.end_time.nil? ? Time.now : session.end_time
      duration = end_time - session.start_time
      total_time += duration
    end
    total_time
  end

  def total_time_in_hours_minutes(time = total_time)
    hours = time / 3600
    minutes = (time % 3600) / 60
    "#{hours.round}h #{minutes.round}m"
  end

  def total_time_working_days(day_length, time = total_time)
    # calculate the total time in days based on the length of a working day (in hours)
    time /= 3600
    (time / day_length).round(2)
  end
end
