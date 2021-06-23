# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Larry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    #config.load_defaults 6.1
    config.load_defaults '5.2'
    config.i18n.default_locale = :ru

    config.generators do |g|
      g.template_engine :slim
    end

    config.autoload_paths += Dir[
      "#{Rails.root}/app/inputs",
      "#{Rails.root}/app/commands",
    ]
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    if ENV.key? 'LARRY_HOST'
      config.hosts << ENV['LARRY_HOST']
      config.hosts << '*.' + ENV['LARRY_HOST']
    end
  end
end
