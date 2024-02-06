# frozen_string_literal: true

# Type: Model (Database) - Project
class Project < Sequel::Model
  plugin :validation_helpers

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
end
