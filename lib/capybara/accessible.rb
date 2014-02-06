require 'capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/element'
require "capybara/accessible/version"
require "capybara/accessible/railtie" if defined?(Rails)

module Capybara
  module Accessible
  end
end

require "capybara/accessible/selenium_extensions"

Capybara.register_driver :accessible do |app|
  Capybara::Selenium::Driver.new(app).tap do |driver|
    driver.extend(Capybara::Accessible::SeleniumExtensions)
  end
end
