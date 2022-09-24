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
    let(:resolver) { instance_double(STAC::ObjectResolver) }

    let(:spy) { instance_spy(STAC::Catalog) }

    before do
      allow(resolver).to receive(:resolve).and_return(spy)
    end

    it 'returns a STAC object resolved from the given URL' do
      object = STAC.from_url(url, resolver: resolver)

      expect(resolver).to have_received(:resolve).with(url)
      expect(object).to eq spy
    end

    context 'when the resolved object does not have `self_href`' do
      before do
        allow(spy).to receive(:self_href).and_return(nil)
      end

      it 'assigns `self_href` with the given url' do
        STAC.from_url(url, resolver: resolver)

        expect(spy).to have_received(:self_href=).with(url)
      end
    end
  end
end
