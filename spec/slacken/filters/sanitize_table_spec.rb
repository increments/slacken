require 'spec_helper'

describe Slacken::Filters::SanitizeTable, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a pre tag occurs in a table' do
      let(:component) do
        c(:table,
          c(:thead,
            c(:tr,
              c(:th, text('Header1')),
              c(:th, text('Header2')))),
          c(:tbody,
            c(:tr,
              c(:td, text('Content1')),
              c(:td, c(:pre, (text('Content2')))))))
      end

      it { is_expected.to be_falsey }
    end

    context 'when only allowed tags occur in a table' do
      let(:component) do
        c(:table,
          c(:thead,
            c(:tr,
              c(:th, text('Header1')),
              c(:th, c(:span, c(:i, text('Header2')))))),
          c(:tbody,
            c(:tr,
              c(:td, c(:code, text('Content1'))),
              c(:td, c(:strong, text('Content2'))))))
      end

      it { is_expected.to be_truthy }
    end
  end
end
