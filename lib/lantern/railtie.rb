require 'rails/railtie'

module Lantern
  class Railtie < Rails::Railtie
    railtie_name :lantern

    # Include the generators
    generators do
      require "lantern/generators/install_generator"
    end
  end
end
