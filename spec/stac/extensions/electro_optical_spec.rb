# frozen_string_literal: true

RSpec.describe STAC::Extensions::ElectroOptical do
  subject(:item) { STAC.from_file(fixture_path('eo/item.json')) }

  describe '#eo_bands' do
    it 'returns Band objects' do
      expect(item.assets['analytic'].eo_bands).to all(be_a STAC::Extensions::ElectroOptical::Band)
    end
  end

  describe '#eo_bands=' do
    it 'overwrites eo:bands field' do
      item.properties.eo_bands = [
        {
          'name' => 'band',
          'common_name' => 'blue',
        },
      ]

      expect(item.properties.eo_bands.first.name).to eq 'band'
    end
  end

  describe '#eo_cloud_cover' do
    it 'returns eo:cloud_cover property value' do
      expect(item.properties.eo_cloud_cover).to eq 1.2
    end
  end

  describe '#eo_cloud_cover=' do
    it 'overwrites eo:cloud_cover field' do
      item.properties.eo_cloud_cover = 10

      expect(item.properties.eo_cloud_cover).to eq 10
    end
  end
end
