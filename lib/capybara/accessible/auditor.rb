module Capybara::Accessible
  class InaccessibleError < Capybara::CapybaraError; end

  class Auditor
    class Node < self
      def initialize(session)
        @driver = session.driver
      end

      def audit!
        if modal_dialog_present?
          puts "Skipping accessibility audit: Modal dialog present"
        else
          super
        end
      end

      private
      def modal_dialog_present?
        Capybara::Accessible.driver_adapter.modal_dialog_present?(driver)
      end
    end

    class Driver < self
      def initialize(driver)
        @driver = driver
      end
    end

    class <<self
      def exclusions=(rules)
        @exclusions = rules
      end

      def exclusions
        @exclusions ||= []
      end

      def log_level=(level)
        @log_level = level
      end

      def log_level
        @log_level ||= :error
      end

      def severe_rules=(rules)
        @severe_rules = rules
      end

      def severe_rules
        @severe_rules ||= []
      end

      def disable
        @disabled = true
      end

      def enable
        @disabled = false
      end

      def disabled?
        @disabled
      end
    end

    def audit!
      return if Auditor.disabled?

      if failures?
        log_level_response[Capybara::Accessible::Auditor.log_level].call(failure_messages)
      end
    end

    private
    attr_reader :driver

    def log_level_response
      @log_level_response ||= {
          warn: ->(messages) { puts messages },
          error: ->(messages) { raise Capybara::Accessible::InaccessibleError, failure_messages }
      }
    end

    def failures?
      failures = run_script(perform_audit_script + driver_adaptor.failures_script)

      Array(failures).any?
    end

    def failure_messages
      result = run_script(perform_audit_script + driver_adaptor.create_report_script)
      "Found at #{page_url} \n\n#{result}"
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
      driver_adaptor.run_javascript(driver, script)
    end

    def driver_adaptor
      Capybara::Accessible.driver_adapter
    end
  end
end
