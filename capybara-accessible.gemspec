# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara/accessible/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara-accessible"
  spec.version       = Capybara::Accessible::VERSION
  spec.authors       = ["Case Commons"]
  spec.email         = ["accessibility@casecommons.org"]
  spec.description   = %q{Capybara extension and webdriver for automated accessibility testing}
  spec.summary       = %q{A Selenium based webdriver and Capybara extension that runs Google Accessibility Developer Tools auditing assertions on page visits.}
  spec.homepage      = "https://github.com/Casecommons/capybara-accessible"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)

  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2.0"
  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "capybara-webkit"
  spec.add_dependency "sauce"
  spec.add_dependency "sauce-connect"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "tddium"

  # Sinatra is used by Capybara's TestApp
  spec.add_development_dependency("sinatra")
end
