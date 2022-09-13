# frozen_string_literal: true

module STAC
  class Extent
    Spatial = Struct.new(:bbox, keyword_init: true)
    Temporal = Struct.new(:interval, keyword_init: true)

    class << self
      def from_hash(hash)
        new(
          spatial: Spatial.new(**hash.fetch('spatial').transform_keys(&:to_sym)),
          temporal: Temporal.new(**hash.fetch('temporal').transform_keys(&:to_sym)),
        )
      end
    end

    attr_accessor :spatial, :temporal

    def initialize(spatial:, temporal:)
      @spatial = spatial
      @temporal = temporal
    end

    def to_h
      {
        'spatial' => spatial.to_h.transform_keys(&:to_s),
        'temporal' => temporal.to_h.transform_keys(&:to_s),
      }
    end
  end
end
