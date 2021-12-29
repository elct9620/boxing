# frozen_string_literal: true

RSpec.describe Boxing::Database do
  subject(:database) { described_class.new('/tmp/dummy') }

  describe '.exist?' do
    subject { described_class.exist? }

    before do
      allow(File).to receive(:directory?).and_return(true)
      allow(Dir).to receive(:entries).and_return(%w[gems])
    end

    it { is_expected.to be_truthy }

    context 'when directory not present?' do
      before do
        allow(File).to receive(:directory?).and_return(false)
      end

      it { is_expected.to be_falsy }
    end

    context 'when directory is empty' do
      before do
        allow(Dir).to receive(:entries).and_return(%w[])
      end

      it { is_expected.to be_falsy }
    end
  end

  describe '.download!' do
    subject(:download) { described_class.download! }

    before do
      allow(described_class).to receive(:system).and_return(true)
    end

    it { is_expected.to be_a(Boxing::Database) }

    context 'when download failed' do
      before do
        allow(described_class).to receive(:system).and_return(false)
      end

      it { expect { download }.to raise_error(Boxing::Database::DownloadFailed) }
    end
  end

  describe '#git?' do
    before do
      allow(File).to receive(:directory?).with('/tmp/dummy/.git').and_return(true)
    end

    it { is_expected.to be_git }

    context 'when .git directory not exist' do
      before do
        allow(File).to receive(:directory?).with('/tmp/dummy/.git').and_return(false)
      end

      it { is_expected.not_to be_git }
    end
  end

  describe '#update!' do
    subject(:update) { database.update! }

    before do
      allow(File).to receive(:directory?).with('/tmp/dummy/.git').and_return(true)
      allow(Dir).to receive(:chdir).and_yield
      allow(database).to receive(:system).and_return(true)
    end

    it { is_expected.to be_truthy }

    context 'when not git repoistory' do
      before do
        allow(File).to receive(:directory?).with('/tmp/dummy/.git').and_return(false)
      end

      it { is_expected.to be_nil }
    end

    context 'when pull failed' do
      before do
        allow(database).to receive(:system).and_return(false)
      end

      it { expect { update }.to raise_error(Boxing::Database::UpdateFailed) }
    end
  end
end
