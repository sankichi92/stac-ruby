# frozen_string_literal: true

require_relative 'errors'
require_relative 'stac_object'

module STAC
  # Represents STAC item.
  #
  # Spec: https://github.com/radiantearth/stac-spec/tree/master/item-spec
  class Item < STACObject
    self.type = 'Feature'

    class << self
      def from_hash(hash)
        h = hash.dup
        h['assets'] = h.fetch('assets').transform_values { |v| Asset.from_hash(v) }
        super(h)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :geometry, :bbox, :properties, :assets, :collection

    def initialize(
      id:, geometry:, properties:, links:, assets:, bbox: nil, collection: nil, stac_extensions: nil, **extra
    )
      super(id: id, links: links, stac_extensions: stac_extensions, **extra)
      @geometry = geometry
      @properties = properties
      @assets = assets
      @bbox = bbox
      @collection = collection
    end

    def to_h
      super.merge(
        {
          'geometry' => geometry, # required but nullable
        },
      ).merge(
        {
          'bbox' => bbox,
          'properties' => properties,
          'assets' => assets.transform_values(&:to_h),
          'collection' => collection,
        }.compact,
      )
    end
  end
end
