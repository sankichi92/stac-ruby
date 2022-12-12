# frozen_string_literal: true

require 'tmpdir'

RSpec.describe STAC::FileWriter do
  subject(:writer) { STAC::FileWriter.new }

  describe '#write' do
    let(:hash) { { 'foo' => :bar } }
    let(:dest) { File.join(Dir.mktmpdir, 'foo/bar.json') }

    it 'writes the given hash as JSON to dest' do
      writer.write(hash, dest: dest)

      expect(File.exist?(dest)).to be true
      expect(File.read(dest)).to eq '{"foo":"bar"}'
    end

    context 'when dest is file:// URI' do
      let(:dest_uri) { "file://#{dest}" }

      it 'writes the given hash as JSON to dest' do
        writer.write(hash, dest: dest_uri)

        expect(File.exist?(dest)).to be true
      end
    end

    context 'when dest is not supported URI scheme' do
      let(:dest_uri) { 'https://example.com/bar.json' }

      it 'raises NotSupportedURISchemeError' do
        expect { writer.write(hash, dest: dest_uri) }.to raise_error STAC::NotSupportedURISchemeError
      end
    end
  end
end
