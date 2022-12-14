# frozen_string_literal: true

RSpec.describe STAC::ObjectResolver do
  subject(:resolver) { STAC::ObjectResolver.new(http_client: http_client) }

  let(:http_client) { instance_double(STAC::SimpleHTTPClient) }

  describe '#resolve' do
    let(:url) { 'https://example.com/catalog' }

    before do
      allow(http_client).to receive(:get).and_return(read_fixture_as_json('stac-spec/catalog.json'))
    end

    it 'opens the given URL and returns a STAC object' do
      object = resolver.resolve(url)

      expect(http_client).to have_received(:get).with(URI(url))
      expect(object).to be_an_instance_of STAC::Catalog
    end

    context 'with file:// URL' do
      let(:url) { "file://#{fixture_path('stac-spec/catalog.json')}" }

      it 'opens a file and returns a STAC object' do
        object = resolver.resolve(url)

        expect(http_client).not_to have_received(:get)
        expect(object).to be_an_instance_of STAC::Catalog
      end
    end

    context 'with unsupported scheme URL' do
      let(:url) { 'ftp://example.com' }

      it 'raises STAC::NotSupportedURISchemeError' do
        expect { resolver.resolve(url) }.to raise_error STAC::NotSupportedURISchemeError
      end
    end

    context 'when it could not resolve any STAC objects' do
      before do
        allow(http_client).to receive(:get).and_return({})
      end

      it 'raises STAC::TypeError' do
        expect { resolver.resolve(url) }.to raise_error STAC::TypeError
      end
    end
  end
end
