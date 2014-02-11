require 'bundler/setup'
require 'queue_classic'
require 'queue_classic/tasks'
require 'sequel'
require 'sequel/extensions/migration'

namespace :db do
  desc "Create database"
  task :create do
    cmd = "createdb simple_builder"
    puts cmd
    Kernel.exec(cmd)
  end

  desc "Run database migrations"
  task :migrate do
    DB = Sequel.connect(ENV["DATABASE_URL"])
    Sequel::Migrator.apply(DB, "db/migrations")
  end

  desc "Rollback the database"
  task :rollback do
    DB = Sequel.connect(ENV["DATABASE_URL"])
    version = (row = DB[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(DB, "db/migrations", version - 1)
  end

  desc "Drop the database (drop all tables)"
  task :drop do
    DB = Sequel.connect(ENV["DATABASE_URL"])
    DB.tables.each do |table|
      DB.run("DROP TABLE #{table}")
    end
  end

  desc "Reset the database"
  task reset: [:drop, :migrate, :"qc:create"]
end
