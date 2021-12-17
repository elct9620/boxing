# frozen_string_literal: true

RSpec.describe Boxing::Dependency do
  subject(:dependency) { described_class.new(dependencies) }

  let(:dependencies) do
    [
      instance_double('Bundler::Dependency', name: 'rails', groups: %i[default])
    ]
  end

  describe '#select' do
    subject { dependency.select('rails') }

    it { is_expected.not_to be_empty }

    context 'when dependency not exists' do
      subject { dependency.select('hanami') }

      it { is_expected.to be_empty }
    end
  end

  describe '#has?' do
    subject { dependency.has?('rails') }

    it { is_expected.to be_truthy }

    context 'when dependency not exits' do
      subject { dependency.has?('hanami') }

      it { is_expected.to be_falsy }
    end
  end
end
