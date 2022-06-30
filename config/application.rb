require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImageboardRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Central Time (US & Canada)'
    config.autoload_paths += [Rails.root.join('app', 'models', 'validators').to_s]
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.deliver_later_queue_name = nil # defaults to "mailers"
    # config.action_mailbox.queues.routing    = nil       # defaults to "action_mailbox_routing"
    # config.active_storage.queues.analysis   = nil       # defaults to "active_storage_analysis"
    # config.active_storage.queues.purge      = nil       # defaults to "active_storage_purge"
    # config.active_storage.queues.mirror     = nil
  end
end
