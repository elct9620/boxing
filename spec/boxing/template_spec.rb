# frozen_string_literal: true

RSpec.describe Boxing::Template do
  subject(:template) { described_class.new('Dockerfile.tt') }

  it { is_expected.to have_attributes(engine: be_a(ERB)) }

  describe '#render' do
    subject(:render) { template.render(context.to_binding) }

    let(:config) { Boxing::Config.new }
    let(:database) { instance_double(Boxing::Database) }
    let(:context) { Boxing::Context.new(config, database, []) }

    before do
      config.root = '/customize/app'
    end

    it { is_expected.to be_a(String) }
    it { is_expected.to include('APP_ROOT=/customize/app') }
  end
end
