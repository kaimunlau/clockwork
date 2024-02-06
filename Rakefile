# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_t, args|
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect('sqlite://db/database.db') do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end

  desc 'Empty all rows of each table'
  task :empty_tables do
    require 'sequel/core'
    Sequel.connect('sqlite://db/database.db') do |db|
      db.tables.each do |table|
        next if table == :schema_info

        db[table].delete
        puts "Emptied table: #{table}"
      end
    end
  end

  desc 'Drop the database'
  task :drop do
    require 'fileutils'
    FileUtils.rm('db/database.db', force: true)
    puts 'Database dropped successfully.'
  end
end

# rubocop:enable Metrics/BlockLength
