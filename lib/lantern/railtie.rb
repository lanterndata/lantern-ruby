require 'rails/railtie'

module Lantern
  class Railtie < Rails::Railtie
    railtie_name :lantern

    generators do
      require 'generators/lantern/lantern_generator'
    end
  end
end
