# frozen_string_literal: true

RSpec.describe STAC::Catalog do
  subject(:catalog) { STAC::Catalog.from_file(catalog_path) }

  let(:catalog_path) { File.expand_path('../../stac-spec/examples/catalog.json', __dir__) }

  describe '.from_file' do
    it 'reads a JSON file and returns a Catalog instance' do
      catalog = STAC::Catalog.from_file(catalog_path)

      expect(catalog).to be_an_instance_of STAC::Catalog
    end
  end

  describe '.from_hash' do
    let(:hash) do
      {
        'stac_version' => '1.0.0',
        'type' => type,
        'id' => '20201211_223832_CS2',
        'description' => 'A simple catalog example',
        'links' => [],
      }
    end
    let(:type) { 'Catalog' }

    it 'returns a Catalog instance based on the given Hash' do
      catalog = STAC::Catalog.from_hash(hash)

      expect(catalog).to be_an_instance_of STAC::Catalog
      expect(catalog.id).to eq '20201211_223832_CS2'
      expect(catalog.description).to eq 'A simple catalog example'
    end

    context 'when "type" is not "Catalog"' do
      let(:type) { 'INVALID' }

      it 'raises TypeError' do
        expect { STAC::Catalog.from_hash(hash) }.to raise_error STAC::TypeError
      end
    end

    context 'when a required field is missing' do
      it 'raises MissingRequiredFieldError' do
        expect { STAC::Catalog.from_hash(hash.except('id')) }.to raise_error STAC::MissingRequiredFieldError
      end
    end
  end

  describe '#to_h' do
    it 'converts self to a Hash' do
      expect(catalog.to_h).to eq JSON.parse(File.read(catalog_path))
    end
  end
end