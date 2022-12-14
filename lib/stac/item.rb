# frozen_string_literal: true

require_relative 'asset'
require_relative 'errors'
require_relative 'properties'
require_relative 'stac_object'

module STAC
  # Represents \STAC item.
  #
  # \STAC \Item Specification: https://github.com/radiantearth/stac-spec/tree/master/item-spec
  class Item < STAC::STACObject
    @type = 'Feature'

    class << self
      def from_hash(hash)
        h = hash.transform_keys(&:to_sym)
        h[:properties] = Properties.from_hash(h.fetch(:properties, {}))
        h[:assets] = h.fetch(:assets, {}).transform_values { |v| Asset.from_hash(v) }
        super(h)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :id, :geometry, :bbox, :collection_id

    attr_reader :properties, :assets

    def initialize(
      id:, geometry:, properties:, links: [], assets: {}, bbox: nil, collection: nil, stac_extensions: [], **extra
    )
      @id = id
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
      super(links: links, stac_extensions: stac_extensions, **extra)
    end

    def [](key)
      value = super
      if value.nil?
        properties.extra[key.to_s]
      else
        value
      end
    end

    def to_h
      super.merge(
        {
          'geometry' => geometry, # required but nullable
        },
      ).merge(
        {
          'id' => id,
          'bbox' => bbox,
          'properties' => properties.to_h,
          'assets' => assets.transform_values(&:to_h),
          'collection' => collection_id,
        }.compact,
      )
    end

    # Returns a rel="collection" link as a collection object if it exists.
    def collection
      link = find_link(rel: 'collection')
      link&.target
    end

    # Overwrites rel="collection" link and #collection_id attribute.
    def collection=(collection)
      @collection_id = collection.id
      remove_links(rel: 'collection')
      add_link(collection, rel: 'collection', type: 'application/json', title: collection.title)
    end

    # Adds an asset with the given key.
    #
    # When the item has extendable stac_extensions, make the asset extend the extension modules.
    def add_asset(key:, href:, title: nil, description: nil, type: nil, roles: nil, **extra)
      asset = Asset.new(href: href, title: title, description: description, type: type, roles: roles, **extra)
      extensions.each do |extension|
        asset.extend(extension::Asset) if extension.const_defined?(:Asset)
      end
      assets[key] = asset
      self
    end

    private

    def respond_to_missing?(symbol, include_all)
      if properties.respond_to?(symbol)
        true
      else
        super
      end
    end

    def method_missing(symbol, *args, **options, &block)
      if properties.respond_to?(symbol)
        properties.public_send(symbol, *args, **options, &block)
      else
        super
      end
    end

    def apply_extension!(extension)
      super
      properties.extend(extension::Properties) if extension.const_defined?(:Properties)
      assets.each_value { |asset| asset.extend(extension::Asset) } if extension.const_defined?(:Asset)
    end
  end
end
