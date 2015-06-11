require 'spec_helper'

class Slacken::DocumentComponent
  describe ElimBlanks, dsl: true do
    describe '#has_no_blanks?' do
      subject { component.has_no_blanks? }

      context 'when a component obviously having no blanks is given' do
        let(:component) do
          c(:div, text('hello world!'))
        end

        it { is_expected.to be_truthy }
      end

      context 'when a component with blank children is given' do
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
end
