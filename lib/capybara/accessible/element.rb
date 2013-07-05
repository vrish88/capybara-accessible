module Capybara
  module Node
    class Element < Base
      include Capybara::Accessible::Auditor

      def click
        synchronize { base.click }

        if @session.driver.is_a? Capybara::Accessible::Driver
          begin
            @session.driver.browser.switch_to.alert
            puts "Skipping accessibility audit: Modal dialog present"
          rescue ::Selenium::WebDriver::Error::NoAlertOpenError, ::NoMethodError
            if audit_failures.any?
              if Capybara::Accessible::Auditor.log_level == :warn
                puts failure_messages
              else
                raise Capybara::Accessible::InaccessibleError, failure_messages
              end
            end
          end
        elsif @session.driver.is_a? Capybara::Accessible::WebkitDriver
          if webkit_audit_failures.any?
            raise Capybara::Accessible::InaccessibleError, webkit_failure_messages
          end
        end
      end
    end
  end
end
