# frozen_string_literal: true

RSpec.describe Boxing::Context do
  subject(:context) { described_class.new(database, []) }

  let(:database) { instance_double(Boxing::Database) }

  describe '#packages' do
    subject { context.packages }

    it { is_expected.to include(Boxing::Package.new('build-base')) }

    context '#when extra package exists' do
      let(:context) { described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)]) }

      before do
        allow(database).to receive(:package_for).with('rails').and_return([Boxing::Package.new('tzdata')])
      end

      it { is_expected.to include(Boxing::Package.new('tzdata')) }
    end
  end

  describe '#default_packages' do
    subject { context.default_packages }

    it { is_expected.to include(Boxing::Package.new('build-base')) }
    it { is_expected.not_to include(Boxing::Package.new('git')) }

    context '#when git source exists' do
      let(:context) do
        described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails', git: true)])
      end

      it { is_expected.to include(Boxing::Package.new('git')) }
    end
  end

  describe '#git?' do
    it { is_expected.not_to be_git }

    context '#when git source exists' do
      subject do
        described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails', git: true)])
      end

      it { is_expected.to be_git }
    end
  end

  describe '#has?' do
    subject { context.has?('rails') }

    it { is_expected.to be_falsy }

    context '#when gem exists' do
      let(:context) { described_class.new(database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)]) }

      it { is_expected.to be_truthy }
    end
  end
end
