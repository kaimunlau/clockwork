# frozen_string_literal: true

# Type: Model (Database) - Project
class Project < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :name
    validates_unique :name
  end
end
