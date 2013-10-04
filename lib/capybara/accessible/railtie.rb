module Capybara
  module Accessible
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'capybara/accessible/tasks.rb'
      end
    end
  end
end
