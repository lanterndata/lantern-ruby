require "test_helper"
require "generators/lantern/lantern_generator"

class LanternGeneratorTest < Rails::Generators::TestCase
  tests Lantern::Generators::LanternGenerator
  destination File.expand_path('../tmp', __dir__)
  setup :prepare_destination

  def test_works
    run_generator
    assert_migration 'db/migrate/install_lantern.rb', /enable_extension "lantern"/
  end
end
