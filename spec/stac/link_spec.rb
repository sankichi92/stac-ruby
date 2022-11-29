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
    it 'deserializes a Link from a Hash' do
      link = STAC::Link.from_hash(hash)

      expect(link).to be_an_instance_of STAC::Link
      expect(link.rel).to eq 'child'
      expect(link.href).to eq './extensions-collection/collection.json'
      expect(link.type).to eq 'application/json'
      expect(link.title).to eq 'Collection Demonstrating STAC Extensions'
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(link.to_h).to eq hash
    end
  end

  describe '#absolute_href' do
    context 'when its HREF is absolute' do
      before do
        link.href = 'https://example.com/absolute'
      end

      it 'returns HREF' do
        expect(link.absolute_href).to eq 'https://example.com/absolute'
      end
    end

    context 'when its HREF is relative and its owner has self HREF' do
      before do
        catalog = STAC::Catalog.new(id: 'catalog', description: 'having self HREF', links: [])
        catalog.self_href = 'https://example.com/catalog.json'
        link.owner = catalog
      end

      it 'returns absolute HREF by joining HREF of owner' do
        expect(link.absolute_href).to eq 'https://example.com/extensions-collection/collection.json'
      end
    end

    context 'when its HREF is relative and its owner does not have self HREF' do
      it 'returns nil' do
        expect(link.absolute_href).to be_nil
      end
    end
  end

  describe '#target' do
    before do
      link.href = "file://#{fixture_path('stac-spec/catalog.json')}"
    end

    it 'returns STAC object resolved from HREF' do
      object = link.target

      expect(object).to be_an_instance_of STAC::Catalog
    end

    context 'when #absolute_href returns nil' do
      before do
        link.href = './relateive.json'
      end

      it 'returns nil' do
        object = link.target

        expect(object).to be_nil
      end
    end
  end
end
