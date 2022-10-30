# frozen_string_literal: true

RSpec.describe STAC::SimpleHTTPClient do
  subject(:client) { STAC::SimpleHTTPClient.new }

  describe '#get' do
    let(:url) { 'https://example.com' }

    it 'makes a HTTP GET request and returns the responded JSON as Hash' do
      request = stub_request(:get, url).to_return(body: { foo: 'bar' }.to_json)

      response = client.get(url)

      expect(request.with(headers: { 'User-Agent' => /\Astac-ruby/ })).to have_been_made
      expect(response).to eq({ 'foo' => 'bar' })
    end

    context 'when the response status is not 2XX' do
      before do
        stub_request(:get, url).to_return(status: 404)
      end

      it 'raises STAC::HTTPError' do
        expect { client.get(url) }.to raise_error STAC::HTTPError
      end
    end
  end
end
