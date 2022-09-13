# frozen_string_literal: true

RSpec.describe STAC::Asset do
  subject(:asset) { STAC::Asset.from_hash(hash) }

  let(:hash) do
    {
      'href' => 'http://cool-sat.com/catalog/CS3-20160503_132130_04/thumbnail.png',
      'title' => 'Thumbnail',
      'type' => 'image/png',
      'roles' => [
        'thumbnail',
      ],
    }
  end

  describe '.from_hash' do
    it 'returns a Asset instance based on the given Hash' do
      asset = STAC::Asset.from_hash(hash)

      expect(asset).to be_an_instance_of STAC::Asset
      expect(asset.href).to eq 'http://cool-sat.com/catalog/CS3-20160503_132130_04/thumbnail.png'
      expect(asset.title).to eq 'Thumbnail'
      expect(asset.description).to be_nil
      expect(asset.type).to eq 'image/png'
      expect(asset.roles).to eq %w[thumbnail]
    end
  end

  describe '#to_h' do
    it 'converts self to a Hash' do
      expect(asset.to_h).to eq hash
    end
  end
end
