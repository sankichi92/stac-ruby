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
    self.type = 'Collection'

    class << self
      def from_hash(hash)
        h = hash.dup
        h['extent'] = Extent.from_hash(h.fetch('extent'))
        h['providers'] = h['providers']&.map { |provider| Provider.from_hash(provider) }
        h['assets'] = h['assets']&.transform_values { |v| Asset.from_hash(v) }
        super(h)
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
      super(id: id, description: description, links: links, title: title, stac_extensions: stac_extensions, **extra)
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
