module Capybara
  module Node
    class Element < Base
      include Capybara::Accessible::Auditor

      def click
        synchronize { base.click }

        if Capybara.current_driver == :accessible
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
        elsif Capybara.current_driver == :accessible_webkit
          if webkit_audit_failures.any?
            raise Capybara::Accessible::InaccessibleError, webkit_failure_messages
          end
        end
      end
    end
  end
end
