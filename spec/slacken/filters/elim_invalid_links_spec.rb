require 'spec_helper'

describe Slacken::Filters::ElimInvalidLinks, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a http link is given' do
      let(:component) do
        c(:a, { href: 'http://example.com' })
      end

      it { is_expected.to be_truthy }
    end

    context 'when a https link is given' do
      let(:component) do
        c(:a, { href: 'https://example.com' })
      end

      it { is_expected.to be_truthy }
    end

    context "when a disallowed link containing 'http://' is given" do
      let(:component) do
        c(:a, { href: '#hogefugahttp://' })
      end

      it { is_expected.to be_falsey }
    end

    context 'when a disallowed link is given' do
      let(:component) do
        c(:a, { href: '#hogehoge' })
      end

      it { is_expected.to be_falsey }
    end

    context 'when a disallowed link occurs as a component\'s component.derive' do
      let(:component) do
        c(:div, c(:span, c(:a, { href: '#hogehoge' })))
      end

      it { is_expected.to be_falsey }
    end
  end
end
