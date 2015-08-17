require 'spec_helper'

module Slacken
  describe DocumentComponent do
    describe '#normalize' do
      subject { DomContainer.parse_html(source).to_component.normalize }
      let(:source) { fixture('example.html') }

      DocumentComponent::NORMALIZE_FILTERS.each do |klass|
        context "when #{klass.name} checks the result's validity" do
          let(:filter) { klass.new }
          it { is_expected.to satisfy(&filter.method(:valid?)) }
        end
      end
    end
  end
end
