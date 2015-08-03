require 'spec_helper'

describe Slacken::Filters::ElimLineBreaks, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when no linebreaks occur' do
      let(:component) do
        c(:div, c(:h1, text('yo!')), c(:wrapper, text('hello world!'), text('another')))
      end

      it { is_expected.to be_truthy }
    end

    context 'when a linebreak occurs in a inline component' do
      let(:component) do
        c(:div, c(:h1, text('yo!')), c(:wrapper, text('hello world!'), text("another\n")))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a linebreak occurs in a block component' do
      let(:component) do
        c(:div, c(:h1, text("yo\n!")), c(:wrapper, text('hello world!'), text("another")))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a linebreak occurs in a pre tag' do
      let(:component) do
        c(:div, c(:pre, text("yo\n!")), c(:wrapper, text('hello world!'), text("another")))
      end

      it { is_expected.to be_truthy }
    end
  end
end
