# frozen_string_literal: true

RSpec.describe Boxing do
  it 'has a version number' do
    expect(Boxing::VERSION).not_to be nil
  end

  describe '.config' do
    subject(:config) { described_class.config }

    it { is_expected.to be_a(Boxing::Config) }
  end
end
