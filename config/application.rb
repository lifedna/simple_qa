require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module SimpleQa
  class Application < Rails::Application
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails rails.validations)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
  end
end
