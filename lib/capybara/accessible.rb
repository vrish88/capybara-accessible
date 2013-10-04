require 'capybara'
require 'capybara/accessible/auditor'
require 'capybara/accessible/element'
require "capybara/accessible/version"
require "capybara/accessible/railtie" if defined?(Rails)

module Capybara
  module Accessible
  end
end

require "capybara/accessible/driver"

Capybara.register_driver :accessible do |app|
  Capybara::Accessible::Driver.new(app)
end
