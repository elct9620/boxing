# frozen_string_literal: true

RSpec.describe Boxing::Utils do
  subject(:utils) do
    Class.new do
      include Boxing::Utils
    end.new
  end

  let(:tmpdir) { Dir.mktmpdir }

  around { |example| Dir.chdir(tmpdir) { example.run } }
  after { FileUtils.remove_entry(tmpdir) }

  describe '#current_path' do
    subject { utils.current_path }

    context 'when Rails is defined' do
      before { stub_const('Rails', double(root: tmpdir)) }

      it { is_expected.to eq(tmpdir) }
    end

    context 'when Hanami is defined' do
      before { stub_const('Hanami', double(app: double(root: tmpdir))) }

      it { is_expected.to eq(tmpdir) }
    end

    context 'when nothing is defined' do
      it do
        realpath = Pathname.new(tmpdir).realpath
        is_expected.to eq(realpath)
      end
    end
  end

  describe '#template' do
    before do
      utils.template('.dockerignore', 'dockerignore.tt', context: Boxing.context)
    end

    it 'creates a file' do
      destination = Pathname.new(tmpdir).join('.dockerignore')
      expect(destination).to be_exist
    end

    it 'renders the template' do
      destination = Pathname.new(tmpdir).join('.dockerignore')
      expect(destination.read).to include('.git/')
    end
  end
end
