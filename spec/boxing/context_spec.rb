# frozen_string_literal: true

RSpec.describe Boxing::Context do
  subject(:context) { described_class.new(config, database, []) }

  let(:config) { Boxing::Config.new }
  let(:database) { instance_double(Boxing::Database) }

  describe '#config' do
    subject { context.config }

    it { is_expected.to be_a(Boxing::Config) }
  end

  describe '#packages' do
    subject { context.packages }

    it { is_expected.to include(Boxing::Package.new('build-base')) }

    context '#when extra package exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)])
      end

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
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: true)])
      end

      it { is_expected.to include(Boxing::Package.new('git')) }
    end
  end

  describe '#git?' do
    it { is_expected.not_to be_git }

    context '#when git source exists' do
      subject do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: true)])
      end

      it { is_expected.to be_git }
    end
  end

  describe '#has?' do
    subject { context.has?('rails') }

    it { is_expected.to be_falsy }

    context '#when gem exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)])
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#entrypoint' do
    subject { context.entrypoint }

    it { is_expected.to include('bundle', 'exec') }

    context 'when customized entrypoint' do
      before do
        config.entrypoint = ['bin/rackup']
      end

      it { is_expected.to include('bin/rackup') }
    end

    context 'when openbox exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'openbox', git: nil)])
      end

      it { is_expected.to include('bin/openbox') }
    end

    context 'when rails exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)])
      end

      it { is_expected.to include('bin/rails') }
    end
  end

  describe '#command' do
    subject { context.command }

    it { is_expected.to include('rackup', '-o', '0.0.0.0') }

    context 'when customized command' do
      before do
        config.command = ['console']
      end

      it { is_expected.to include('console') }
    end

    context 'when openbox exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'openbox', git: nil)])
      end

      it { is_expected.to include('server') }
    end

    context 'when rails exists' do
      let(:context) do
        described_class.new(config, database, [instance_double('Bundler::Dependency', name: 'rails', git: nil)])
      end

      it { is_expected.to include('server', '-b', '0.0.0.0') }
    end
  end
end
