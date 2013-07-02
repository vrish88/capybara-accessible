module Capybara::Accessible
  class InaccessibleError < Capybara::CapybaraError; end

  module Auditor
    def self.exclusions=(rules)
      @@exclusions = rules
    end

    def self.exclusions
      @@exclusions ||= []
    end

    def audit_rules
      File.read(File.expand_path("../axs_testing.js", __FILE__))
    end

    def audit_failures
      script =<<-JAVASCRIPT
        var config = new axs.AuditConfiguration();
        config.auditRulesToIgnore = #{excluded_rules.to_json};
        results = axs.Audit.run(config);
        return axs.Audit.auditResults(results).getErrors();
      JAVASCRIPT

      run_script("#{audit_rules} #{script}")
    end

    def failure_messages
      run_script("#{audit_rules} var results = axs.Audit.run(); return axs.Audit.createReport(results)")
    end

    private

    def excluded_rules
      Capybara::Accessible::Auditor.exclusions
    end

    def run_script(script)
      if @session
        @session.driver.execute_script(script)
      else
        execute_script(script)
      end
    end
  end
end
