# frozen_string_literal: true

RSpec.describe STAC::Link do
  subject(:link) { STAC::Link.from_hash(hash) }

  let(:hash) do
    {
      'rel' => 'child',
      'href' => './extensions-collection/collection.json',
      'type' => 'application/json',
      'title' => 'Collection Demonstrating STAC Extensions',
    }
  end

  describe '.from_hash' do
    it 'returns a Link instance based on the given Hash' do
      link = STAC::Link.from_hash(hash)

      expect(link).to be_an_instance_of STAC::Link
      expect(link.rel).to eq 'child'
      expect(link.href).to eq './extensions-collection/collection.json'
      expect(link.type).to eq 'application/json'
      expect(link.title).to eq 'Collection Demonstrating STAC Extensions'
    end
  end

  describe '#to_h' do
    it 'converts self to a Hash' do
      expect(link.to_h).to eq hash
    end
  end
end
