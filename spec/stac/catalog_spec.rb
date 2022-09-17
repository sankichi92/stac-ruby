# frozen_string_literal: true

RSpec.describe STAC::Catalog do
  subject(:catalog) { STAC::Catalog.from_file(catalog_path) }

  let(:catalog_path) { File.expand_path('../../stac-spec/examples/catalog.json', __dir__) }

  describe '.from_file' do
    it 'reads a JSON file and returns an instance of Catalog' do
      catalog = STAC::Catalog.from_file(catalog_path)

      expect(catalog).to be_an_instance_of STAC::Catalog
    end

    context 'when the JSON does not have ref="self" link' do
      let(:catalog_path) { File.expand_path('../fixtures/catalog-without-self.json', __dir__) }

      it 'adds a rel="self" link with the given path' do
        catalog = STAC::Catalog.from_file(catalog_path)

        expect(catalog.self_href).to eq catalog_path
      end
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

    it 'deserializes a Catalog from a Hash' do
      catalog = STAC::Catalog.from_hash(hash)

      expect(catalog).to be_an_instance_of STAC::Catalog
      expect(catalog.id).to eq '20201211_223832_CS2'
      expect(catalog.description).to eq 'A simple catalog example'
    end

    context 'when the value of `type` is not "Catalog"' do
      let(:type) { 'INVALID' }

      it 'raises TypeError' do
        expect { STAC::Catalog.from_hash(hash) }.to raise_error STAC::TypeError
      end
    end

    context 'when a required field is missing' do
      it 'raises ArgumentError' do
        expect { STAC::Catalog.from_hash(hash.except('links')) }.to raise_error ArgumentError
      end
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(catalog.to_h).to eq JSON.parse(File.read(catalog_path))
    end
  end

  describe '#to_json' do
    it 'serializes self to a JSON string' do
      expect { JSON.parse(catalog.to_json) }.not_to raise_error
    end
  end

  describe '#add_link' do
    it 'adds a link with setting its `owner` as self' do
      link = STAC::Link.new(rel: 'child', href: './child.json', type: 'application/json')
      catalog.add_link(link)

      expect(catalog.links).to include link
      expect(link.owner).to eq catalog
    end
  end

  describe '#self_href' do
    it 'returns HREF of the rel="self" link' do
      expect(catalog.self_href).to eq 'https://raw.githubusercontent.com/radiantearth/stac-spec/v1.0.0/examples/catalog.json'
    end
  end
end
