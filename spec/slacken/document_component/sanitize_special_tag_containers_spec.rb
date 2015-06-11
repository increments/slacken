require 'spec_helper'

class Slacken::DocumentComponent
  describe SanitizeSpecialTagContainers, dsl: true do
    describe '#sanitized?' do
      subject { component.sanitized? }

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

      context 'when a code occurs in a header' do
        let(:component) do
          c(:h3,
            text('A Ruby Code is Given: '),
            c(:span,
              c(:code, text("puts('hello, world!')"))))
        end

        it { is_expected.to be_falsey }
      end

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
    end
  end
end
