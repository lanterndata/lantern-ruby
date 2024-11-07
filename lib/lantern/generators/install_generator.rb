require 'rails/generators/active_record'

module Lantern
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_migration_file
        migration_template 'install_lantern.rb.tt', 'db/migrate/install_lantern.rb'
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Migration.next_migration_number(current_migration_number(dirname) + 1)
      end
    end
  end
end