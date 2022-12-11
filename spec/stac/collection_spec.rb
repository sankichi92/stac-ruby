# frozen_string_literal: true

RSpec.describe STAC::Collection do
  subject(:collection) { STAC.from_file(collection_path) }

  let(:collection_path) { fixture_path('stac-spec/collection.json') }

  describe '.from_hash' do
    let(:hash) do
      {
        'stac_version' => '1.0.0',
        'type' => 'Collection',
        'license' => 'ISC',
        'id' => '20201211_223832_CS2',
        'description' => 'A simple collection example',
        'links' => [],
        'extent' => {
          'spatial' => {
            'bbox' => [
              [
                172.91173669923782,
                1.3438851951615003,
                172.95469614953714,
                1.3690476620161975,
              ],
            ],
          },
          'temporal' => {
            'interval' => [
              [
                '2020-12-11T22:38:32.125Z',
                '2020-12-14T18:02:31.437Z',
              ],
            ],
          },
        },
        'summaries' => {},
      }
    end

    it 'deserializes a Collection from a Hash' do
      collection = STAC::Collection.from_hash(hash)

      expect(collection).to be_an_instance_of STAC::Collection
      expect(collection.id).to eq '20201211_223832_CS2'
      expect(collection.description).to eq 'A simple collection example'
      expect(collection.license).to eq 'ISC'
    end

    context 'when a required field is missing' do
      it 'raises ArgumentError' do
        expect { STAC::Collection.from_hash(hash.except('extent')) }.to raise_error ArgumentError
      end
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(collection.to_h).to eq JSON.parse(File.read(collection_path))
    end
  end

  describe '#add_asset' do
    it 'adds an asset' do
      collection.add_asset(key: 'thumbnail', href: './asset.tiff')

      expect(collection.assets['thumbnail'].href).to eq './asset.tiff'
    end

    context 'when the item has a stac_extension' do
      before do
        collection.add_extension(STAC::Extensions::ScientificCitation)
      end

      it 'adds an asset with extension' do
        collection.add_asset(key: 'thumbnail', href: './asset.tiff')

        expect(collection.assets['thumbnail']).to be_a STAC::Extensions::ScientificCitation::Asset
      end
    end
  end

  describe '#add_item' do
    before do
      collection.self_href = "file://#{collection_path}"
    end

    let(:item) { STAC.from_file(fixture_path('stac-spec/simple-item.json')) }

    it 'adds a item link with setting `collection` as self' do
      collection.add_item(item)

      expect(item.collection).to be collection
    end
  end
end
