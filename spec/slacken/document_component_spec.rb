require 'spec_helper'

module Slacken
  describe DocumentComponent do
    let(:document_component) { described_class.build_by_html(source) }
    let(:source) { fixture('example.html') }

    describe '#normalize' do
      subject { document_component.normalize }

      DocumentComponent::NORMALIZE_FILTERS.each do |klass|
        context "when #{klass.name} checks the result's validity" do
          let(:filter) { klass.new }
          it { is_expected.to satisfy(&filter.method(:valid?)) }
        end
      end
    end
  end
end
