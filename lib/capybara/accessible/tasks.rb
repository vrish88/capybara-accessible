require 'csv'
require 'rake'
# require 'capybara/accessible'

namespace :capybara_accessible do
  task :report_inaccessible_tests do
    directories = Dir["features/**"].concat(Dir['spec/features/**'])
    directories.map! { |d| [d.split('/').last, d]}
    directories.sort!

    total_inaccessible_tests = 0
    total_tests = 0
    CSV.open("output_#{DateTime.now.strftime("%Y%m%dT%H%M")}.csv", 'w') do |csv|
      csv<<['Module', 'Test Folder Path', 'Inaccessible Tests', 'Accessible Tests', 'Total Tests']

      directories.each do |key, directory|
        if directory.split('/').first == 'features'
          inaccessible_count = `git grep "@inaccessible" #{directory} | wc -l`
          total_count = `git grep "Scenario" #{directory} | wc -l`
        else
          inaccessible_count = `git grep "inaccessible.*true" #{directory} | wc -l`
          total_count = `git grep "scenario.*do" #{directory} | wc -l`
        end
        total_inaccessible_tests += inaccessible_count.to_i
        total_tests += total_count.to_i

        csv << ["#{key.upcase}",  "#{directory}", inaccessible_count.to_i, (total_count.to_i - inaccessible_count.to_i), total_count.to_i]
      end
      csv << ['TOTALS',  '', total_inaccessible_tests, total_tests - total_inaccessible_tests, total_tests]
    end
  end
end
