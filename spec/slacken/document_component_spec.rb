require 'spec_helper'

describe Slacken::DocumentComponent, dsl: true do
  let(:document_component) { described_class.build_by_html(source) }
  # If you change the behavior, you should run `scripts/update_markup_fixture.rb`
  # to update fixture file.
  let(:source) { fixture('example.html') }

  describe '#normalize' do
    subject { document_component.normalize }

    Slacken::DocumentComponent::NORMALIZE_FILTERS.each do |klass|
      context "when #{klass.name} checks the result's validity" do
        let(:filter) { klass.new }
        it { is_expected.to satisfy(&filter.method(:valid?)) }
      end
    end
  end

  describe '#==' do
    subject { component1 == component2 }

    describe 'when the two are the same object' do
      let(:component1) do
        c(:ul,
          c(:li,
            text('header'),
            c(:img, class: 'emoji', alt: 'emoji_code'),
            c(:indent,
              c(:h1, text('hoge')))))
      end
      let(:component2) do
        component1
      end

      it { is_expected.to be_truthy }
    end

    describe 'when the two have same structure' do
      let(:component1) do
        c(:ul,
          c(:li,
            text('header'),
            c(:img, class: 'emoji', alt: 'emoji_code'),
            c(:indent,
              c(:h1, text('hoge')))))
      end
      let(:component2) do
        c(:ul,
          c(:li,
            text('header'),
            c(:img, class: 'emoji', alt: 'emoji_code'),
            c(:indent,
              c(:h1, text('hoge')))))
      end

      it { is_expected.to be_truthy }
    end

    describe "when the two's children are different " do
      let(:component1) do
        c(:ul,
          c(:li,
            text('header'),
            c(:img, class: 'emoji', alt: 'emoji_code'),
            c(:indent,
              c(:h1, text('hoge')))))
      end
      let(:component2) do
        c(:ul,
          c(:li,
            c(:img, class: 'emoji', alt: 'emoji_code'),
            text('footer'),
            c(:indent,
              c(:h1, text('hoge')))))
      end

      it { is_expected.to be_falsey }
    end

    describe "when the two's attributes are different " do
      let(:component1) do
        c(:img, class: 'emoji', alt: 'hoge')
      end
      let(:component2) do
        c(:img, class: 'emoji', alt: 'fuga')
      end

      it { is_expected.to be_falsey }
    end

    describe "when the two's types are different " do
      let(:component1) do
        c(:img, class: 'emoji', alt: 'hoge')
      end
      let(:component2) do
        c(:a, class: 'emoji', alt: 'fuga')
      end

      it { is_expected.to be_falsey }
    end
  end
end
