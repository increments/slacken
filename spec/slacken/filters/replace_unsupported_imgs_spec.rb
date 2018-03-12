require 'spec_helper'

describe Slacken::Filters::ReplaceUnsupportedImgs, dsl: true do
  describe '#call' do
    subject { described_class.new.call(component) }

    context 'when a supported img is given' do
      let(:component) do
        c(:img, src: 'http://example.com/example.png')
      end

      it { is_expected.to eq component }
    end

    context 'when an unsupported img is given' do
      let(:component) do
        c(:img, src: 'data:image/png;base64,ZXhhbXBsZQo=')
      end

      let(:placeholder) do
        text('&lt;img src="data:..."&gt;')
      end

      it { is_expected.to eq placeholder }
    end

    context 'when a given component is not an img' do
      let(:component) do
        text('text')
      end

      it { is_expected.to eq component }
    end
  end
end
