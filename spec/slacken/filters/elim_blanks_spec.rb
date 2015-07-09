require 'spec_helper'

describe Slacken::Filters::ElimBlanks, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a component obviously having no blanks is given' do
      let(:component) do
        c(:div, text('hello world!'))
      end

      it { is_expected.to be_truthy }
    end

    context 'when a component with blank component.derive is given' do
      let(:component) do
        c(:div, text(''), c(:div), c(:span))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a component with a img is given' do
      let(:component) do
        c(:div, c(:img))
      end

      it { is_expected.to be_truthy }
    end

  end
end
