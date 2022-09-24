# frozen_string_literal: true

RSpec.describe STAC::Collection do
  subject(:collection) { STAC.from_file(collection_path) }

  let(:collection_path) { File.expand_path('../../stac-spec/examples/collection.json', __dir__) }

  describe '.from_hash' do
    let(:hash) do
      {
        'stac_version' => '1.0.0',
        'type' => type,
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
    let(:type) { 'Collection' }

    it 'deserializes a Collection from a Hash' do
      collection = STAC::Collection.from_hash(hash)

      expect(collection).to be_an_instance_of STAC::Collection
      expect(collection.id).to eq '20201211_223832_CS2'
      expect(collection.description).to eq 'A simple collection example'
      expect(collection.license).to eq 'ISC'
    end

    context 'when the value of `type` is not "Collection"' do
      let(:type) { 'INVALID' }

      it 'raises TypeError' do
        expect { STAC::Collection.from_hash(hash) }.to raise_error STAC::TypeError
      end
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
end
