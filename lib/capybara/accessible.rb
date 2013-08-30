require 'capybara'
require 'capybara/webkit'
require 'sauce/capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/element'
require "capybara/accessible/version"

module Capybara
  module Accessible
  end
end

require "capybara/accessible/driver"
require "capybara/accessible/webkit_driver"
require "capybara/accessible/sauce_driver"

Capybara.register_driver :accessible do |app|
  Capybara::Accessible::Driver.new(app)
end

Capybara.register_driver :accessible_webkit do |app|
  Capybara::Accessible::WebkitDriver.new(app)
end

Capybara.register_driver :accessible_sauce do |app|
  Capybara::Accessible::SauceDriver.new(app)
end
