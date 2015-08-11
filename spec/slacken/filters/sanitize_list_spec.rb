
require 'spec_helper'

describe Slacken::Filters::SanitizeList, dsl: true do
  describe '#valid?' do
    subject { described_class.new.valid?(component) }

    context 'when a header occurs in a list' do
      let(:component) do
        c(:ul,
          c(:li,
            text('header'),
            c(:indent,
              c(:h1, text('hoge')))))
      end

      it { is_expected.to be_falsey }
    end

    context 'when a list occurs in another list' do
      let(:component) do
        c(:ul,
          c(:li,
            text('header'),
            c(:indent,
              c(:dl,
                c(:li,
                  text('header2'),
                  c(:indent,
                    text('fuga')))))))
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#call' do
    let(:filter) { described_class.new.call(component) }

    context 'when a list has a img tag' do
      let(:component) do
        c(:ul, c(:img))
      end

      it 'changes img to div tag' do
        expect(filter.children.first.type.name).to eq :div
      end
    end
  end
end
