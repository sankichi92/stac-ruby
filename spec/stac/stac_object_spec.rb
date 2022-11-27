# frozen_string_literal: true

RSpec.describe STAC::STACObject do
  describe '.extendables' do
    it 'returns available extension modules' do
      expect(STAC::STACObject.extendables).to all(be_a STAC::Extension)
    end
  end

  describe '.add_extendables' do
    let(:extension) do
      Module.new do
        extend STAC::Extension

        self.identifier = 'extension'
        self.scope = []
      end
    end

    after do
      STAC::STACObject.class_variable_get(:@@extendables).delete(extension.identifier)
    end

    it 'adds an extension module to extendables' do
      STAC::STACObject.add_extendable(extension)

      expect(STAC::STACObject.extendables).to include extension
    end
  end
end
