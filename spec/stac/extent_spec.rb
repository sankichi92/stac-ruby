# frozen_string_literal: true

RSpec.describe STAC::Extent do
  subject(:extent) { STAC::Extent.from_hash(hash) }

  let(:hash) do
    {
      'spatial' => {
        'bbox' => [
          [
            172.91173669923782,
            1.3438851951615003,
            172.95469614953714,
            1.3690476620161975,
          ],
        ],
      },
      'temporal' => {
        'interval' => [
          [
            '2020-12-11T22:38:32.125Z',
            '2020-12-14T18:02:31.437Z',
          ],
        ],
      },
    }
  end

  describe '.from_hash' do
    it 'deserializes an Extent from a Hash' do
      extent = STAC::Extent.from_hash(hash)

      expect(extent).to be_an_instance_of STAC::Extent
      expect(extent.spatial.bbox).to eq [[
        172.91173669923782, 1.3438851951615003, 172.95469614953714, 1.3690476620161975,
      ]]
      expect(extent.temporal.interval).to eq [['2020-12-11T22:38:32.125Z', '2020-12-14T18:02:31.437Z']]
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(extent.to_h).to eq hash
    end
  end
end
