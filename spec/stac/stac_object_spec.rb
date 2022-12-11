# frozen_string_literal: true

RSpec.describe STAC::STACObject do
  subject(:stac_object) { STAC::STACObject.new }

  describe '.extendables' do
    it 'returns available extension modules' do
      expect(STAC::STACObject.extendables).to all(be_a STAC::Extension)
    end
  end

  describe '.add_extendables' do
    let(:extension) do
      Module.new do
        extend STAC::Extension

        identifier 'extension'
      end
    end

    after do
      STAC::STACObject.class_variable_get(:@@extendables).delete(extension.identifier)
    end

    it 'adds an extension module to extendables' do
      STAC::STACObject.add_extendable(extension)

      expect(STAC::STACObject.extendables).to include extension
    end
  end

  describe '#add_link' do
    it 'adds a link with setting its `owner` as self' do
      stac_object.add_link(rel: 'test', href: './test.json', type: 'application/json')

      link = stac_object.find_link(rel: 'test')
      expect(link).not_to be_nil
      expect(link.owner).to be stac_object
    end

    context 'without target and href' do
      it 'raises ArgumentError' do
        expect { stac_object.add_link(rel: 'test', type: 'application/json') }.to raise_error ArgumentError
      end
    end
  end

  describe '#self_href= and #self_href' do
    it 'overwrites rel="self" link and returns HREF of it' do
      stac_object.self_href = fixture_path('object.json')

      expect(stac_object.self_href).to end_with 'object.json'
    end
  end

  describe '#root= and #root' do
    let(:catalog) { STAC::Catalog.new(id: 'id', description: 'description') }

    it 'overwrites rel="root" link and returns it as a catalog object' do
      stac_object.root = catalog

      expect(stac_object.root).to be catalog
    end
  end

  describe '#parent= and #parent' do
    let(:collection) { STAC.from_file(fixture_path('stac-spec/collection.json')) }

    it 'overwrites rel="parent" link and returns it as a catalog object' do
      stac_object.parent = collection

      expect(stac_object.parent).to be collection
    end
  end
end
