# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      String :name, null: false, unique: true

      timestamp :created_at
      timestamp :updated_at
    end
  end
end
