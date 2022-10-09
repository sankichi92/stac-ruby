# frozen_string_literal: true

require_relative 'asset'
require_relative 'errors'
require_relative 'properties'
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
        h['properties'] = Properties.from_hash(h.fetch('properties'))
        h['assets'] = h.fetch('assets').transform_values { |v| Asset.from_hash(v) }
        super(h)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :geometry, :bbox, :properties, :assets, :collection_id

    def initialize(
      id:, geometry:, properties:, links:, assets:, bbox: nil, collection: nil, stac_extensions: nil, **extra
    )
      super(id: id, links: links, stac_extensions: stac_extensions, **extra)
      @geometry = geometry
      @properties = properties
      @assets = assets
      @bbox = bbox
      case collection
      when Collection
        self.collection = collection
      else
        @collection_id = collection
      end
    end

    def to_h
      super.merge(
        {
          'geometry' => geometry, # required but nullable
        },
      ).merge(
        {
          'bbox' => bbox,
          'properties' => properties.to_h,
          'assets' => assets.transform_values(&:to_h),
          'collection' => collection_id,
        }.compact,
      )
    end

    # Returns datetime from #properties.
    def datetime
      properties.datetime
    end

    # Returns a rel="collection" link as a collection object if it exists.
    def collection
      link = find_link(rel: 'collection')
      link&.target
    end

    # Overwrites rel="collection" link and #collection_id attribute.
    def collection=(collection)
      raise ArgumentError, 'collection must have a rel="self" link' unless (collection_href = collection.self_href)

      @collection_id = collection.id
      collection_link = Link.new(
        rel: 'collection',
        href: collection_href,
        type: 'application/json',
        title: collection.title,
      )
      remove_link(rel: 'collection')
      add_link(collection_link)
    end
  end
end
