# frozen_string_literal: true

RSpec.describe STAC::Provider do
  subject(:provider) { STAC::Provider.from_hash(hash) }

  let(:hash) do
    {
      'name' => 'Remote Data, Inc',
      'description' => 'Producers of awesome spatiotemporal assets',
      'roles' => %w[
        producer
        processor
      ],
      'url' => 'http://remotedata.io',
    }
  end

  describe '.from_hash' do
    it 'deserializes a Provider from a Hash' do
      provider = STAC::Provider.from_hash(hash)

      expect(provider).to be_an_instance_of STAC::Provider
      expect(provider.name).to eq 'Remote Data, Inc'
      expect(provider.description).to eq 'Producers of awesome spatiotemporal assets'
      expect(provider.roles).to eq %w[producer processor]
      expect(provider.url).to eq 'http://remotedata.io'
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(provider.to_h).to eq hash
    end
  end
end
