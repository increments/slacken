require 'spec_helper'

describe Slacken::Filters::SanitizeLink, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a image occurs in a link' do
      let(:component) do
        c(:a, c(:img))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a strong occurs in a link' do
      let(:component) do
        c(:a,  c(:strong, text('content')))
      end

      it { is_expected.to be_truthy }
    end
  end
end
