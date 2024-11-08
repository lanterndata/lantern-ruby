require 'rails/generators'
require 'rails/generators/active_record'

module Lantern
  module Generators
    class LanternGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      source_root File.join(__dir__, 'templates')

      def copy_migration
        migration_template 'lantern.rb.tt', 'db/migrate/install_lantern.rb', migration_version: migration_version
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
