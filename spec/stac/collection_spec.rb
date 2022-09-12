# frozen_string_literal: true

RSpec.describe STAC::Collection do
  subject(:collection) { STAC::Collection.from_file(collection_path) }

  let(:collection_path) { File.expand_path('../../stac-spec/examples/collection.json', __dir__) }

  describe '.from_file' do
    it 'reads a JSON file and returns a Collection instance' do
      collection = STAC::Collection.from_file(collection_path)

      expect(collection).to be_an_instance_of STAC::Collection
    end
  end

  describe '.from_hash' do
    let(:hash) do
      {
        'stac_version' => '1.0.0',
        'type' => type,
        'license' => 'ISC',
        'id' => '20201211_223832_CS2',
        'description' => 'A simple collection example',
        'links' => [],
        'extent' => {},
        'summaries' => {},
      }
    end
    let(:type) { 'Collection' }

    it 'returns a Collection instance based on the given Hash' do
      collection = STAC::Collection.from_hash(hash)

      expect(collection).to be_an_instance_of STAC::Collection
      expect(collection.id).to eq '20201211_223832_CS2'
      expect(collection.description).to eq 'A simple collection example'
      expect(collection.license).to eq 'ISC'
    end

    context 'when "type" is not "Collection"' do
      let(:type) { 'INVALID' }

      it 'raises TypeError' do
        expect { STAC::Collection.from_hash(hash) }.to raise_error STAC::TypeError
      end
    end

    context 'when a required field is missing' do
      it 'raises MissingRequiredFieldError' do
        expect { STAC::Collection.from_hash(hash.except('id')) }.to raise_error STAC::MissingRequiredFieldError
      end
    end
  end

  describe '#to_h' do
    it 'converts self to a Hash' do
      expect(collection.to_h).to eq JSON.parse(File.read(collection_path))
    end
  end
end