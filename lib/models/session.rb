# frozen_string_literal: true

# Type: Model (Database) - Session
class Session < Sequel::Model
  plugin :validation_helpers

  many_to_one :project

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
    validates_presence :project_id
  end
end
