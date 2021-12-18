# frozen_string_literal: true

RSpec.describe Boxing::Context do
  subject(:context) { described_class.new(database, []) }

  let(:database) { instance_double(Boxing::Database) }

  describe '#packages' do
    subject { context.packages }

    it { is_expected.to be_empty }

    context '#when package exists' do
      let(:context) { described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails')]) }

      before do
        allow(database).to receive(:package_for).with('rails').and_return([Boxing::Package.new('tzdata')])
      end

      it { is_expected.to include(Boxing::Package.new('tzdata')) }
    end
  end

  describe '#has?' do
    subject { context.has?('rails') }

    it { is_expected.to be_falsy }

    context '#when gem exists' do
      let(:context) { described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails')]) }

      it { is_expected.to be_truthy }
    end
  end
end
