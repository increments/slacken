require 'spec_helper'

describe Slacken do
  describe '#translate' do
    subject { described_class.translate(source) }
    let(:source) { fixture('example.html') }

    # This test checks whether the behavior of this translation engine is unexpectedly broken.
    # If you change the behavior, you should run `scripts/update_markup_fixture.rb`
    # to update fixture file.
    it 'translates as expected' do
      expect(subject).to eq(fixture('markup_text.txt'))
    end
  end
end
