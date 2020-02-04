require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
  end
end
