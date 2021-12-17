# frozen_string_literal: true

RSpec.describe Boxing::Package do
  subject(:package) { described_class.new('openssl-dev', '~1.1.1') }

  describe '#build?' do
    it { is_expected.not_to be_build }

    context 'when mark as build' do
      subject { described_class.new('openssl-dev', '~1.1.1', mode: 0b10) }

      it { is_expected.to be_build }
    end
  end

  describe '#runtime?' do
    it { is_expected.to be_runtime }

    context 'when mark as build only' do
      subject { described_class.new('openssl-dev', '~1.1.1', mode: 0b10) }

      it { is_expected.not_to be_runtime }
    end
  end

  describe '#==' do
    subject { package == other }

    let(:other) { described_class.new('openssl-dev', '~1.2.1') }

    it { is_expected.to be_truthy }

    context 'when package is different' do
      let(:other) { described_class.new('openssl', '~1.1.1') }

      it { is_expected.to be_falsy }
    end
  end

  describe '#to_s' do
    subject { package.to_s }

    it { is_expected.to eq('openssl-dev=~1.1.1') }

    context 'when version not given' do
      let(:package) { described_class.new('openssl-dev') }

      it { is_expected.to eq('openssl-dev') }
    end
  end
end
