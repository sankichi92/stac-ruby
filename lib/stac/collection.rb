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

        new(
          id: hash.fetch('id'),
          description: hash.fetch('description'),
          links: hash.fetch('links').map { |link| Link.from_hash(link) },
          license: hash.fetch('license'),
          extent: Extent.from_hash(hash.fetch('extent')),
          title: hash['title'],
          keywords: hash['keywords'],
          providers: hash['providers']&.map { |provider| Provider.from_hash(provider) },
          summaries: hash['summaries'],
          assets: hash['assets']&.transform_values { |v| Asset.from_hash(v) },
          stac_extensions: hash['stac_extensions'],
          extra_fields: hash.except(
            *%w[
              type stac_version
              id description links license extent title keywords providers summaries assets stac_extensions
            ],
          ),
        )
      rescue KeyError => e
        raise MissingRequiredFieldError, "required field not found: #{e.key}"
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
      extra_fields: {}
    )
      super(
        id: id,
        description: description,
        links: links,
        title: title,
        stac_extensions: stac_extensions,
        extra_fields: extra_fields
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
