# frozen_string_literal: true

require_relative 'hash_like'

module STAC
  # Represents \STAC extent object, which describes the spatio-temporal extents of a Collection.
  #
  # Specification: https://github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md#extent-object
  class Extent
    include HashLike

    class << self
      # Deserializes an Extent from a Hash.
      def from_hash(hash)
        transformed = hash.transform_keys(&:to_sym)
        transformed[:spatial] = Spatial.from_hash(transformed.fetch(:spatial))
        transformed[:temporal] = Temporal.from_hash(transformed.fetch(:temporal))
        new(**transformed)
      end
    end

    attr_accessor :spatial, :temporal

    def initialize(spatial:, temporal:, **extra)
      @spatial = spatial
      @temporal = temporal
      @extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
    def to_h
      {
        'spatial' => spatial.to_h,
        'temporal' => temporal.to_h,
      }.merge(extra)
    end

    # Describes the spatial extents of a Collection
    class Spatial
      include HashLike

      # Deserializes a Spatial from a Hash.
      def self.from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end

      attr_accessor :bbox

      def initialize(bbox:, **extra)
        @bbox = bbox
        @extra = extra.transform_keys(&:to_s)
      end

      # Serializes self to a Hash.
      def to_h
        {
          'bbox' => bbox,
        }.merge(extra)
      end
    end

    # Describes the temporal extents of a Collection.
    class Temporal
      include HashLike

      # Deserializes a Temporal from a Hash.
      def self.from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end

      attr_accessor :interval

      def initialize(interval:, **extra)
        @interval = interval
        @extra = extra.transform_keys(&:to_s)
      end

      # Serializes self to a Hash.
      def to_h
        {
          'interval' => interval,
        }.merge(extra)
      end
    end
  end
end
