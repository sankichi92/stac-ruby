# frozen_string_literal: true

RSpec.describe STAC::Catalog do
  subject(:catalog) { STAC.from_file(catalog_path) }

  let(:catalog_path) { fixture_path('stac-spec/catalog.json') }

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
      catalog.add_link(rel: 'test', href: './test.json', type: 'application/json')

      link = catalog.find_link(rel: 'test')
      expect(link).not_to be_nil
      expect(link.owner).to eq catalog
    end

    context 'without target and href' do
      it 'raises ArgumentError' do
        expect { catalog.add_link(rel: 'test', type: 'application/json') }.to raise_error ArgumentError
      end
    end
  end

  describe '#self_href' do
    it 'returns HREF of the rel="self" link' do
      expect(catalog.self_href).to eq 'https://raw.githubusercontent.com/radiantearth/stac-spec/v1.0.0/examples/catalog.json'
    end
  end

  describe '#children' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns STAC objects from rel="child" links' do
      children = catalog.children

      expect(children.map(&:id)).to contain_exactly 'extensions-collection', 'sentinel-2', 'sentinel-2'
    end
  end

  describe '#collections' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns collection objects from rel="child" links' do
      collections = catalog.collections

      expect(collections.map(&:id)).to contain_exactly 'extensions-collection', 'sentinel-2', 'sentinel-2'
    end
  end

  describe '#all_collections' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns all catalogs/collections from this catalog and its child catalogs recursively' do
      collections = catalog.all_collections

      expect(collections.map(&:id)).to contain_exactly 'extensions-collection', 'sentinel-2', 'sentinel-2'
    end
  end

  describe '#find_child' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns the STAC object with the given ID from rel="child" links' do
      child = catalog.find_child('extensions-collection')

      expect(child.id).to eq 'extensions-collection'
    end

    context 'with option `recursive: true`' do
      it 'finds the STAC object from all child catalogs recursively' do
        child = catalog.find_child('not-found', recursive: true)

        expect(child).to be_nil
      end
    end
  end

  describe '#items' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns item objects from rel="item" links' do
      items = catalog.items

      expect(items.map(&:id)).to contain_exactly 'CS3-20160503_132131_08'
    end
  end

  describe '#all_items' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns all items from this catalog and its child catalogs recursively' do
      items = catalog.all_items

      expect(items.map(&:id)).to contain_exactly 'CS3-20160503_132131_08', 'proj-example'
    end
  end

  describe '#find_item' do
    before do
      catalog.self_href = "file://#{catalog_path}"
    end

    it 'returns the item with the given ID from rel="item" links' do
      item = catalog.find_item('CS3-20160503_132131_08')

      expect(item.id).to eq 'CS3-20160503_132131_08'
    end

    context 'with option `recursive: true`' do
      it 'finds the item from all child catalogs recursively' do
        item = catalog.find_item('proj-example', recursive: true)

        expect(item.id).to eq 'proj-example'
      end
    end
  end
end
