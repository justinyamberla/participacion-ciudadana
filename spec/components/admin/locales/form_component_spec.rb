require "rails_helper"

describe Admin::Locales::FormComponent do
  let(:default_locale) { :nl }
  let(:enabled_locales) { %i[en nl] }

  let(:component) do
    Admin::Locales::FormComponent.new(enabled_locales, default: default_locale)
  end

  describe "default language selector" do
    before { allow(I18n).to receive(:available_locales).and_return(%i[de en es nl]) }

    it "renders radio buttons when there are only a few locales" do
      render_inline component

      page.find(:fieldset, "Default language") do |fieldset|
        expect(fieldset).to have_checked_field "Nederlands", type: :radio
        expect(fieldset).to have_unchecked_field "English", type: :radio
        expect(fieldset).to have_unchecked_field "Español", type: :radio
        expect(fieldset).to have_unchecked_field "Deutsch", type: :radio
      end

      expect(page).not_to have_select
    end

    it "renders a select when there are many locales" do
      allow(component).to receive(:select_field_threshold).and_return(3)

      render_inline component

      expect(page).not_to have_field type: :radio

      expect(page).to have_select "Default language",
                                  options: %w[English Español Deutsch Nederlands],
                                  selected: "Nederlands"
    end
  end
end
