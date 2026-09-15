namespace :db do
  desc "Create the deployed app's PostgreSQL schema"
  task create_app_schema: :environment do
    if Rails.env.production?
      schema = ENV.fetch("DATABASE_SCHEMA")
      abort "Invalid DATABASE_SCHEMA" unless %w[review staging production].include?(schema)

      connection = ActiveRecord::Base.connection
      connection.execute("CREATE SCHEMA IF NOT EXISTS #{connection.quote_column_name(schema)}")
    end
  end
end
