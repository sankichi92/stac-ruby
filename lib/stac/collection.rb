# frozen_string_literal: true

require_relative 'asset'
require_relative 'catalog'
require_relative 'extent'
require_relative 'provider'

module STAC
  # Represents \STAC collection.
  #
  # \STAC \Collection Specification: https://github.com/radiantearth/stac-spec/tree/master/collection-spec
  class Collection < Catalog
    @type = 'Collection'

    class << self
      def from_hash(hash)
        h = hash.transform_keys(&:to_sym)
        h[:extent] = Extent.from_hash(h.fetch(:extent))
        h[:providers] = h[:providers]&.map { |provider| Provider.from_hash(provider) }
        h[:assets] = h[:assets]&.transform_values { |v| Asset.from_hash(v) }
        super(h)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :license, :extent, :keywords, :providers, :summaries

    attr_reader :assets

    def initialize(
      id:,
      description:,
      license:,
      extent:,
      links: [],
      title: nil,
      keywords: nil,
      providers: nil,
      summaries: nil,
      assets: nil,
      stac_extensions: [],
      **extra
    )
      @license = license
      @extent = extent
      @keywords = keywords
      @providers = providers
      @summaries = summaries
      @assets = assets
      super(id: id, description: description, links: links, title: title, stac_extensions: stac_extensions, **extra)
    end

    # Serializes self to a Hash.
    def to_h
      super.merge(
        {
          'license' => license,
          'keywords' => keywords,
          'extent' => extent.to_h,
          'providers' => providers&.map(&:to_h),
          'summaries' => summaries,
          'assets' => assets&.transform_values(&:to_h),
        }.compact,
      )
    end

    # Adds an asset with the given key.
    #
    # When the item has extendable stac_extensions, make the asset extend the extension modules.
    def add_asset(key:, href:, title: nil, description: nil, type: nil, roles: nil, **extra)
      asset = Asset.new(href: href, title: title, description: description, type: type, roles: roles, **extra)
      extensions.each do |extension|
        asset.extend(extension::Asset) if extension.const_defined?(:Asset)
      end
      if assets
        assets[key] = asset
      else
        @assets = { key => asset }
      end
      self
    end

    private

    def apply_extension!(extension)
      super
      extend(extension::Collection) if extension.const_defined?(:Collection)
      assets&.each_value { |asset| asset.extend(extension::Asset) } if extension.const_defined?(:Asset)
    end
  end
end
