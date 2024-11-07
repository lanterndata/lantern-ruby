require 'rails/generators'
require 'rails/generators/active_record'

module Lantern
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      source_root File.join(__dir__, 'templates')

      def copy_migration
        migration_template 'lantern.rb', 'db/migrate/install_lantern.rb', migration_version: migration_version
      end

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
