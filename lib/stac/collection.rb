# frozen_string_literal: true

require_relative 'asset'
require_relative 'catalog'
require_relative 'extent'
require_relative 'provider'

module STAC
  class Collection < Catalog
    class << self
      def from_hash(hash)
        raise TypeError, "type field is not 'Collection': #{hash['type']}" if hash.fetch('type') != 'Collection'

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        transformed[:links] = transformed.fetch(:links).map { |link| Link.from_hash(link) }
        transformed[:extent] = Extent.from_hash(transformed.fetch(:extent))
        transformed[:providers] = transformed[:providers]&.map { |provider| Provider.from_hash(provider) }
        transformed[:assets] = transformed[:assets]&.transform_values { |v| Asset.from_hash(v) }
        new(**transformed)
      rescue KeyError, ArgumentError => e
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

    def to_h
      super.merge(
        {
          'type' => 'Collection',
          'keywords' => keywords,
          'license' => license,
          'providers' => providers.map(&:to_h),
          'extent' => extent.to_h,
          'assets' => assets&.transform_values(&:to_h),
          'summaries' => summaries,
        }.compact,
      )
    end
  end
end
