require 'spec_helper'

describe Slacken::Filters::GroupIndent, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a indented list component is given' do
      let(:component) do
        c(:ul,
          c(:li,
            text('List Heading'),
            c(:indent,
              text('List Content1'),
              c(:span, text('List Content2'), text('List Content3'))
          )))
      end

      it { is_expected.to be_truthy }
    end

    context 'when a indented list where child component is not indented is given' do
      let(:component) do
        c(:ul,
          c(:li,
            text('List Heading'),
            c(:span,
              text('List Content1'),
              c(:span, text('List Content2'), text('List Content3'))
          )))
      end

      it { is_expected.to be_falsey }
    end
  end
end
