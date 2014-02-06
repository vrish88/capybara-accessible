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
  driver = Capybara::Selenium::Driver.new(app)
  adaptor = Capybara::Accessible::SeleniumDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end

Capybara.register_driver :webkit_accessible do |app|
  driver = Capybara::Webkit::Driver.new(app)
  adaptor = Capybara::Accessible::WebkitDriverAdapter.new
  Capybara::Accessible.setup(driver, adaptor)
end
