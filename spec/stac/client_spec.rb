# frozen_string_literal: true

RSpec.describe STAC::Client do
  describe ".open" do
    it "opens the given root catalog of a STAC Catalog or API and returns a client instance" do
      request = stub_request(:get, "https://example.com/stac")

      client = STAC::Client.open("https://example.com/stac")

      expect(request).to have_been_made
      expect(client).to be_an_instance_of STAC::Client
    end
  end
end
