require_relative "boot"

require "rails"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pokerhands
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # service settings
    config.autoload_paths += %W(#{config.root}/app/services)

    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

  end
end
