ENV["AMBER_ENV"] ||= "test"

require "spec"
require "micrate"

require "../config/application"
require "../src/utils/**"

# Micrate::DB.connection_url = ENV["DATABASE_URL"]? || Amber.settings.database_url
# Automatically run migrations on the test database
# Micrate::Cli.run_up
