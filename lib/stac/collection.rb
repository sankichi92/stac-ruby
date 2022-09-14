# frozen_string_literal: true

require_relative 'asset'
require_relative 'catalog'
require_relative 'extent'
require_relative 'provider'

module STAC
  # Represents STAC collection.
  #
  # Spec: https://github.com/radiantearth/stac-spec/tree/master/collection-spec
  class Collection < Catalog
    class << self
      # Deserializes a Collection from a Hash.
      #
      # When the value of `type` is not "Collection", it raises STAC::TypeError.
      # And when a required field is missing, it raises ArgumentError.
      def from_hash(hash)
        raise TypeError, "type field is not 'Collection': #{hash['type']}" if hash.fetch('type') != 'Collection'

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        transformed[:links] = transformed.fetch(:links).map { |link| Link.from_hash(link) }
        transformed[:extent] = Extent.from_hash(transformed.fetch(:extent))
        transformed[:providers] = transformed[:providers]&.map { |provider| Provider.from_hash(provider) }
        transformed[:assets] = transformed[:assets]&.transform_values { |v| Asset.from_hash(v) }
        new(**transformed)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :license, :extent, :keywords, :providers, :summaries, :assets

    def initialize(
      id:,
      description:,
      links:,
      license:,
      extent:,
      title: nil,
      keywords: nil,
      providers: nil,
      summaries: nil,
      assets: nil,
      stac_extensions: nil,
      **extra
    )
      super(
        id: id,
        description: description,
        links: links,
        title: title,
        stac_extensions: stac_extensions,
        **extra
      )
      @license = license
      @extent = extent
      @keywords = keywords
      @providers = providers
      @summaries = summaries
      @assets = assets
    end

    # Serializes self to a Hash.
    def to_h
      super.merge(
        {
          'type' => 'Collection',
          'license' => license,
          'keywords' => keywords,
          'extent' => extent.to_h,
          'providers' => providers&.map(&:to_h),
          'summaries' => summaries,
          'assets' => assets&.transform_values(&:to_h),
        }.compact,
      )
    end
  end
end
