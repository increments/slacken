require 'spec_helper'

module MarkupTranslator
  describe DocumentComponent do
    describe '#normalize' do
      subject { NokogiriParser.parse_html(source).to_component.normalize }
      let(:source) { fixture('example.html') }

      it { is_expected.to have_no_blanks }
      it { is_expected.to have_no_invalid_links }
      it { is_expected.to have_no_line_breaks }
      it { is_expected.to be_indent_grouped }
      it { is_expected.to be_inlines_grouped }
      it { is_expected.to be_sanitized }
    end
  end
end
