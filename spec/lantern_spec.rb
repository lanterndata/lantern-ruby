require 'spec_helper'

RSpec.describe Lantern do
  it 'has a version number' do
    expect(Lantern::VERSION).not_to be nil
  end

  it 'enables the lantern extension' do
    # Define the migration class directly
    class InstallLantern < ActiveRecord::Migration[6.0]
      def change
        enable_extension 'lantern'
      end
    end

    # Run the migration
    ActiveRecord::Migration.suppress_messages do
      InstallLantern.new.change
    end

    extensions = ActiveRecord::Base.connection.extensions
    expect(extensions).to include('lantern')
  end
end
