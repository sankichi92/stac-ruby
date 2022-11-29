# frozen_string_literal: true

RSpec.describe STAC::Extensions::ScientificCitation do
  describe 'Extended item' do
    subject(:item) { STAC.from_file(fixture_path('scientific/item.json')) }

    it 'has methods for Scientific Citation extension' do
      expect(item.properties.sci_doi).to eq '10.5061/dryad.s2v81.2/27.2'
      expect(item.properties.sci_publications.first.doi).to eq '10.5061/dryad.s2v81.2'
    end
  end

  describe 'Extended collection' do
    subject(:collection) { STAC.from_file(fixture_path('scientific/collection.json')) }

    it 'has methods for Scientific Citation extension' do
      expect(collection.sci_citation).to start_with 'Vega GC'
      expect(collection.sci_publications.first.citation).to start_with 'Vega GC'
    end
  end

  describe 'Extended collection asset' do
    subject(:collection) { STAC.from_file(fixture_path('scientific/collection-assets.json')) }

    it 'has methods for Scientific Citation extension' do
      expect(collection.assets['test'].sci_doi).to eq '10.5061/dryad.s2v81.2'
    end
  end
end
