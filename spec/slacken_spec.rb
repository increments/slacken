require 'spec_helper'

describe Slacken do
  describe '#translate' do
    subject { described_class.translate(source) }
    let(:source) { fixture('example.html') }

    it 'translates as expected' do
      expect(subject).to eq(fixture('markup_text.txt'))
    end
  end
end
