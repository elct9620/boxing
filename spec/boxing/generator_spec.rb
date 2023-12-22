# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Boxing::Generator do
  subject(:generator) { described_class.new }

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
  let(:template) { instance_double(Boxing::Template) }

  before do
    allow(generator).to receive(:current_path).and_return(tmpdir)
    allow(template).to receive(:render).and_return('test')

    generator.execute('Dockerfile', template)
  end
  after { FileUtils.remove_entry(tmpdir) }

  it 'creates a file' do
    expect(File.exist?(File.join(tmpdir, 'Dockerfile'))).to be true
  end

  it 'writes the template to the file' do
    expect(File.read(File.join(tmpdir, 'Dockerfile'))).to eq 'test'
  end
end
