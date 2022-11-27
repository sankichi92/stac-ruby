# frozen_string_literal: true

RSpec.describe STAC::Extensions::Projection do
  describe 'Extended item' do
    subject(:item) { STAC.from_file(fixture_path('projection/item.json')) }

    it 'has methods for Peojction extension' do
      expect(item.properties.proj_epsg).to eq 32659
    end
  end
end
