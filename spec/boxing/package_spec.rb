# frozen_string_literal: true

RSpec.describe Boxing::Package do
  subject(:package) { described_class.new('openssl-dev', '~1.1.1') }

  describe '#to_s' do
    subject { package.to_s }

    it { is_expected.to eq('openssl-dev=~1.1.1') }

    context 'when version not given' do
      let(:package) { described_class.new('openssl-dev') }

      it { is_expected.to eq('openssl-dev') }
    end
  end
end
