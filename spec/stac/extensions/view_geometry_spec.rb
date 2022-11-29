# frozen_string_literal: true

RSpec.describe STAC::Extensions::ViewGeometry do
  describe 'Extended item' do
    subject(:item) { STAC.from_file(fixture_path('view/item.json')) }

    it 'has methods for Peojction extension' do
      expect(item.properties.view_sun_elevation).to eq 54.9
      expect(item.properties.view_off_nadir).to eq 3.8
      expect(item.properties.view_sun_azimuth).to eq 135.7
    end
  end
end
