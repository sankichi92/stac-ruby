# frozen_string_literal: true

RSpec.describe STAC::HashLike do
  subject(:hash_like) { hash_like_class.new(foo: 'bar', hoge: 'fuga') }

  let(:hash_like_class) do
    Class.new do
      include STAC::HashLike

      def self.from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end

      attr_accessor :foo

      def initialize(foo:, **extra)
        @foo = foo
        @extra = extra.transform_keys(&:to_s)
      end

      def to_h
        extra.merge({ 'foo' => foo })
      end
    end
  end

  describe '#[]' do
    it 'returns an attribute value or an `extra` hash value' do
      expect(hash_like[:foo]).to eq 'bar'
      expect(hash_like[:hoge]).to eq 'fuga'
      expect(hash_like[:invalie]).to be_nil
    end
  end

  describe '#[]=' do
    context 'with a key matching an attribute name' do
      it 'assigns the attribute' do
        hash_like[:foo] = 'new value'

        expect(hash_like.foo).to eq 'new value'
      end
    end

    context 'with a key not matching any attribute names' do
      it 'adds the given key-value pair to `extra`' do
        hash_like[:new] = 'value'

        expect(hash_like.extra['new']).to eq 'value'
      end
    end
  end

  describe '#update' do
    it 'assigns attributes or merges `extra` hash with the args' do
      hash_like.update(foo: 'updated', hoge: 'updated')

      expect(hash_like.foo).to eq 'updated'
      expect(hash_like.extra['hoge']).to eq 'updated'
    end
  end

  describe '#==' do
    let(:other) { hash_like_class.new(foo: 'bar', hoge: 'fuga') }

    context 'when the given arg has the same values' do
      it 'returns true' do
        expect(hash_like).to eq other
      end
    end

    context 'when the given arg has different values' do
      before do
        other.foo = 'BAR'
      end

      it 'returns false' do
        expect(hash_like).not_to eq other
      end
    end
  end

  describe '#deep_dup' do
    it 'returns a deep copy of self' do
      copy = hash_like.deep_dup

      expect(copy).to eq hash_like
      expect(copy.foo).to eq hash_like.foo
      expect(copy.extra).to eq hash_like.extra

      expect(copy).not_to be hash_like
      expect(copy.foo).not_to be hash_like.foo
      expect(copy.extra).not_to be hash_like.extra
    end
  end
end
