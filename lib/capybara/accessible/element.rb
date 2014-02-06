module Capybara
  module Node
    class Element < Base
      def click
        synchronize { base.click }
        begin
          @session.driver.browser.switch_to.alert
          puts "Skipping accessibility audit: Modal dialog present"
        rescue ::Selenium::WebDriver::Error::NoAlertOpenError, ::NoMethodError
          auditor = Capybara::Accessible::Auditor::Node.new(@session)
          auditor.audit!
        end
      end
    end
  end
end
