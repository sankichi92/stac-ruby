# frozen_string_literal: true

RSpec.describe STAC do
  describe '.from_file' do
    let(:path) do
      Pathname.new('../stac-spec/examples/catalog.json')
              .expand_path(__dir__)
              .relative_path_from(Pathname.pwd)
              .to_s
    end

    it 'returns a STAC object resolved from the given path' do
      catalog = STAC.from_file(path)

      expect(catalog).to be_an_instance_of STAC::Catalog
    end
  end

  describe '.from_url' do
    let(:url) { 'https://example.com/catalog' }
    let(:http_client) { instance_double(STAC::SimpleHTTPClient) }

    before do
      allow(http_client).to receive(:get).and_return(
        {
          'stac_version' => '1.0.0',
          'type' => 'Catalog',
          'id' => '20201211_223832_CS2',
          'description' => 'A simple catalog example',
          'links' => [],
        },
      )
    end

    it 'returns a STAC object resolved from the given URL' do
      object = STAC.from_url(url, http_client: http_client)

      expect(http_client).to have_received(:get).with(URI(url))
      expect(object).to be_an_instance_of STAC::Catalog
      expect(object.self_href).to eq url
    end
  end
end
