# frozen_string_literal: true

RSpec.describe STAC::Properties do
  subject(:properties) { STAC::Properties.from_hash(hash) }

  let(:hash) do
    {
      'datetime' => '2022-10-08T13:27:30Z',
    }
  end

  describe '.from_hash' do
    it 'deserializes a Properties from a Hash' do
      properties = STAC::Properties.from_hash(hash)

      expect(properties).to be_an_instance_of STAC::Properties
      expect(properties.datetime).to eq Time.parse('2022-10-08T13:27:30Z')
    end
  end

  describe '#to_h' do
    it 'serializes self to a Hash' do
      expect(properties.to_h).to eq hash
    end
  end
end
