# frozen_string_literal: true

RSpec.describe STAC::Item do
  subject(:item) { STAC.from_file(item_path) }

  let(:item_path) { File.expand_path('../../stac-spec/examples/core-item.json', __dir__) }

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
      expect(item.collection).to eq 'simple-collection'
    end

    context 'when a required field is missing' do
      it 'raises ArgumentError' do
        expect { STAC::Collection.from_hash(hash.except('assets')) }.to raise_error ArgumentError
      end
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(item.to_h.except('links')).to eq JSON.parse(File.read(item_path)).except('links')
    end
  end
end
