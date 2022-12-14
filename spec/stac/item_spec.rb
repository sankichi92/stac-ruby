# frozen_string_literal: true

RSpec.describe STAC::Item do
  subject(:item) { STAC.from_file(item_path) }

  let(:item_path) { fixture_path('stac-spec/core-item.json') }

  describe '.from_hash' do
    let(:hash) do
      {
        'stac_version' => '1.0.0',
        'type' => 'Feature',
        'id' => '20201211_223832_CS2',
        'bbox' => [],
        'geometry' => {},
        'properties' => {},
        'collection' => 'simple-collection',
        'links' => [],
        'assets' => {},
      }
    end

    it 'deserializes an Item from a Hash' do
      item = STAC::Item.from_hash(hash)

      expect(item).to be_an_instance_of STAC::Item
      expect(item.id).to eq '20201211_223832_CS2'
      expect(item.collection_id).to eq 'simple-collection'
    end

    context 'when a required field is missing' do
      it 'raises ArgumentError' do
        expect { STAC::Collection.from_hash(hash.except('assets')) }.to raise_error ArgumentError
      end
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(item.to_h.except('links')).to eq JSON.parse(File.read(item_path)).except('links', 'stac_extensions')
    end
  end

  describe '#collection' do
    it 'returns a rel="collection link as a collection object' do
      collection = item.collection

      expect(collection).to be_an_instance_of STAC::Collection
    end
  end

  describe '#collection=' do
    it 'overwrites a rel="collection" link and attribute `collection_id` attribute' do
      item.collection = STAC.from_file(fixture_path('stac-spec/collection-only/collection.json'))

      expect(item.collection_id).to eq 'sentinel-2'
      collection_links = item.links.select { |l| l.rel == 'collection' }
      expect(collection_links.size).to eq 1
      expect(collection_links.first.title).to eq 'Sentinel-2 MSI: MultiSpectral Instrument, Level-1C'
    end
  end

  describe '#add_asset' do
    it 'adds an asset' do
      item.add_asset(key: 'thumbnail', href: './asset.tiff')

      expect(item.assets['thumbnail'].href).to eq './asset.tiff'
    end

    context 'when the item has a stac_extension' do
      before do
        item.add_extension(STAC::Extensions::ElectroOptical)
      end

      it 'adds an asset with extension' do
        item.add_asset(key: 'thumbnail', href: './asset.tiff')

        expect(item.assets['thumbnail']).to be_a STAC::Extensions::ElectroOptical::Asset
      end
    end
  end

  describe '#method_missing' do
    it "calls properties' method" do
      expect(item.datetime).to be_nil
    end
  end
end
