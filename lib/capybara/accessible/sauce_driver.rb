module Capybara::Accessible
  class SauceDriver < Sauce::Capybara::Driver
    include Capybara::Accessible::Auditor

    def visit(path)
      super
      if webkit_audit_failures.any?
        raise Capybara::Accessible::InaccessibleError, webkit_failure_messages
      end
    end
  end
end
