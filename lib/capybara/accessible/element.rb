module Capybara
  module Node
    class Element < Base
      def click
        synchronize { base.click }
        Capybara::Accessible::Auditor::Node.new(@session).audit!
      end
    end
  end
end
