require 'spec_helper'

describe "Using poltergeist driver" do
  require "capybara/poltergeist"
  before do
    @session = Capybara::Session.new(:accessible_poltergeist, AccessibleApp)
  end

  context 'a page without accessibility errors' do
    it 'does not raise an exception on audit failures' do
      expect { @session.visit('/accessible') }.to_not raise_error
    end
  end

  context 'a page with inaccessible elements' do
    it 'raises an exception on visiting the page' do
      expect { @session.visit('/inaccessible') }.to raise_error(Capybara::Accessible::InaccessibleError)
    end

    it 'raises an exception when visiting the page via a link' do
      @session.visit('/accessible')
      expect { @session.click_link('inaccessible') }.to raise_error(Capybara::Accessible::InaccessibleError)
    end

    context 'with configuration that excludes rules' do
      before do
        Capybara::Accessible::Auditor.exclusions = ['AX_TEXT_01']
      end

      it 'does not raise an error on an excluded rule' do
        expect { @session.visit('/excluded') }.to_not raise_error
      end
    end

    context 'a page with a javascript popup' do
      it 'does not raise an exception' do
        @session.visit('/alert')
        expect { @session.click_link('Alert!') }.to_not raise_error
      end
    end

    context 'with severity set to severe' do
      before do
        Capybara::Accessible::Auditor.severe_rules = ['AX_TEXT_02']
      end

      after do
        Capybara::Accessible::Auditor.severe_rules = []
      end

      it 'raises an exception on the image without alt text' do
        expect { @session.visit('/severe') }.to raise_error(Capybara::Accessible::InaccessibleError)
      end
    end
  end
end
