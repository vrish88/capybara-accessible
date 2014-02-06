require 'capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/element'
require 'capybara/accessible/driver_extensions'
require "capybara/accessible/version"
require "capybara/accessible/railtie" if defined?(Rails)

module Capybara
  module Accessible
  end
end

Capybara.register_driver :accessible do |app|
  Capybara::Accessible.driver(app)
end
