require 'spec_helper'

describe Slacken::Filters::StringfyEmoji, dsl: true do
  describe '#call' do
    subject { described_class.new.call(component) }

    context "when the img tag's alt is ':emoji_code:'" do
      let(:component) do
        c(:img, class: 'emoji', alt: ':emoji_code:')
      end

      it { is_expected.to eq(c(:emoji, content: 'emoji_code')) }
    end

    context "when the img tag's alt is 'emoji_code'" do
      let(:component) do
        c(:img, class: 'emoji', alt: 'emoji_code')
      end

      it { is_expected.to eq(c(:emoji, content: 'emoji_code')) }
    end
  end
end
