# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:sessions) do
      primary_key :id
      DateTime :start_time
      DateTime :end_time
      foreign_key :project_id, :projects

      timestamp :created_at
      timestamp :updated_at
    end
  end
end
