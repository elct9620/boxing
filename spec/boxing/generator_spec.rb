# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Boxing::Generator do
  subject(:generator) { described_class.new('Dockerfile', 'test') }

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  around { |example| Dir.chdir(tmpdir) { example.run } }
  after { FileUtils.remove_entry(tmpdir) }

  before { generator.execute }

  it 'creates a file' do
    expect(File.exist?(File.join(tmpdir, 'Dockerfile'))).to be true
  end

  it 'writes the template to the file' do
    expect(File.read(File.join(tmpdir, 'Dockerfile'))).to eq 'test'
  end
end
