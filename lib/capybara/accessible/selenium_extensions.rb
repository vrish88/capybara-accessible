module Capybara::Accessible::SeleniumExtensions
  def visit(path)
    super
    auditor = Capybara::Accessible::Auditor::Driver.new(self)
    auditor.audit!
  end
end
