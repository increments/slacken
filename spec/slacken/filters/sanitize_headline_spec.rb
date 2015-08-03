require 'spec_helper'

describe Slacken::Filters::SanitizeHeadline, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a code occurs in a header' do
      let(:component) do
        c(:h3,
          text('A Ruby Code is Given: '),
          c(:span,
            c(:code, text("puts('hello, world!')"))))
      end

      it { is_expected.to be_falsey }
    end

    context 'when only allowed tags occur in a header' do
      let(:component) do
        c(:h3,
          text('hoge'),
          c(:i, text('fuga')),
          c(:span, text('piyo')))
      end

      it { is_expected.to be_truthy }
    end
  end
end
