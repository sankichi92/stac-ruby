# frozen_string_literal: true

RSpec.describe STAC::DefaultHTTPClient do
  subject(:client) { STAC::DefaultHTTPClient.new }

  describe '#get' do
    let(:url) { 'https://example.com' }

    it 'makes a HTTP request and returns the response body as String' do
      request = stub_request(:get, url).to_return(body: 'body')

      response = client.get(URI(url))

      expect(request.with(headers: { 'User-Agent' => /\Astac-ruby/ })).to have_been_made
      expect(response).to eq 'body'
    end

    context 'when the response status is not 2XX' do
      before do
        stub_request(:get, url).to_return(status: 404)
      end

      it 'raises STAC::HTTPError' do
        expect { client.get(URI(url)) }.to raise_error STAC::HTTPError
      end
    end
  end
end
