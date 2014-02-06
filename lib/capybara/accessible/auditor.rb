module Capybara::Accessible
  class InaccessibleError < Capybara::CapybaraError; end

  class << self
    def skip_audit
      @disabled = true
      yield
    ensure
      @disabled = false
    end
  end

  class Auditor
    class Node < self
      def initialize(session)
        @driver = session.driver
      end
    end

    class Driver < self
      def initialize(driver)
        @driver = driver
      end
    end

    def self.exclusions=(rules)
      @@exclusions = rules
    end

    def self.exclusions
      @@exclusions ||= []
    end

    def self.log_level=(level)
      @@log_level= level
    end

    def self.log_level
      @@log_level ||= :error
    end

    def self.severe_rules=(rules)
      @@severe_rules = rules
    end

    def self.severe_rules
      @@severe_rules ||= []
    end

    def audit!
      if audit_failures.any?
        if Capybara::Accessible::Auditor.log_level == :warn
          puts failure_messages
        else
          raise Capybara::Accessible::InaccessibleError, failure_messages
        end
      end
    end

    private
    attr_reader :driver

    def audit_failures
      if Capybara::Accessible.instance_variable_get(:@disabled)
        []
      else
        run_script("#{perform_audit_script} return axs.Audit.auditResults(results).getErrors();")
      end
    end

    def failure_messages
      "Found at #{page_url} \n\n" + run_script("#{perform_audit_script} return axs.Audit.createReport(results)")
    end

    def audit_rules
      File.read(File.expand_path("../../../vendor/google/accessibility-developer-tools/axs_testing.js", __FILE__))
    end

    def perform_audit_script
      <<-JAVASCRIPT
        #{audit_rules}
        var config = new axs.AuditConfiguration();
        var severe_rules = #{severe_rules.to_json};
        var rule;

        for(rule in severe_rules) {
          config.setSeverity(severe_rules[rule], axs.constants.Severity.SEVERE);
        }
        config.auditRulesToIgnore = #{excluded_rules.to_json};

        var results = axs.Audit.run(config);
      JAVASCRIPT
    end

    def excluded_rules
      codes = Capybara::Accessible::Auditor.exclusions
      codes.map { |code| mapping[code]}
    end

    def severe_rules
      codes = Capybara::Accessible::Auditor.severe_rules
      codes.map { |code| mapping[code]}
    end

    def mapping
      @mapping ||= {
          'AX_ARIA_01' => 'badAriaRole',
          'AX_ARIA_02' => 'nonExistentAriaLabelledbyElement',
          'AX_ARIA_03' => 'requiredAriaAttributeMissing',
          'AX_ARIA_04' => 'badAriaAttributeValue',
          'AX_TEXT_01' => 'controlsWithoutLabel',
          'AX_TEXT_02' => 'imagesWithoutAltText',
          'AX_TITLE_01' => 'pageWithoutTitle',
          'AX_IMAGE_01' => 'elementsWithMeaningfulBackgroundImage',
          'AX_FOCUS_01' => 'focusableElementNotVisibleAndNotAriaHidden',
          'AX_FOCUS_02' => 'unfocusableElementsWithOnClick',
          'AX_COLOR_01' => 'lowContrastElements',
          'AX_VIDEO_01' => 'videoWithoutCaptions',
          'AX_AUDIO_01' => 'audioWithoutControls'
          # 'AX_TITLE_01' => 'linkWithUnclearPurpose', # This has a duplicate name
          # 'AX_ARIA_05' => '', # This has no rule associated with it
      }
    end

    def page_url
      driver.current_url
    end

    def run_script(script)
      driver.execute_script(script)
    end
  end
end
