# frozen_string_literal: true

require "rails/generators"

module ActiveRecord
  module Generators
    class TwoFactorAuthenticationGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(_)
        Time.now.utc.strftime("%Y%m%d%H%M%S") # Generates a timestamp-based migration number
      end

      def copy_two_factor_authentication_migration
        migration_template "migration.rb.erb", "db/migrate/two_factor_authentication_add_to_#{table_name}.rb"
      end
    end
  end
end
