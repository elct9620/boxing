# frozen_string_literal: true

RSpec.describe Boxing::Config do
  subject(:config) { described_class.new }

  describe '#root' do
    subject { config.root }

    it { is_expected.to eq('/src/app') }
  end
end
