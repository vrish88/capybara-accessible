module Capybara::Accessible::DriverExtensions
  def visit(path)
    super
    Capybara::Accessible::Auditor::Driver.new(self).audit!
  end
end
