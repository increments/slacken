require 'spec_helper'

describe Slacken::Filters::GroupInlines, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a grouped component is given' do
      let(:component) do
        c(:div, c(:wrapper, text('hello world!'), text('another')))
      end

      it { is_expected.to be_truthy }
    end

    context 'when a component whose inline components are exposed is given' do
      let(:component) do
        c(:div, text(''), c(:div), c(:span))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a component with only block components is given' do
      let(:component) do
        c(:div, c(:div), c(:img), c(:p, c(:h1)))
      end

      it { is_expected.to be_truthy }
    end
  end
end
