# frozen_string_literal: true

require 'time'
require_relative 'common_metadata'
require_relative 'hash_like'

module STAC
  # Represents \STAC properties object, which is additional metadata for Item.
  #
  # Specification: https://github.com/radiantearth/stac-spec/blob/master/item-spec/item-spec.md#properties-object
  class Properties
    include HashLike
    include CommonMetadata

    class << self
      # Deserializes a Properties from a Hash.
      def from_hash(hash)
        h = hash.transform_keys(&:to_sym)
        h[:datetime] = h[:datetime] ? Time.iso8601(h[:datetime]) : nil
        new(**h)
      end
    end

    attr_accessor :datetime

    def initialize(datetime:, **extra)
      @datetime = datetime
      @extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
    def to_h
      {
        'datetime' => datetime&.iso8601,
      }.merge(extra)
    end
  end
end
