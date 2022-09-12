# frozen_string_literal: true

require_relative 'catalog'

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
          extent: hash.fetch('extent'),
          title: hash['title'],
          keywords: hash['keywords'],
          providers: hash['providers'],
          summaries: hash['summaries'],
          assets: hash['assets'],
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
      {
        'stac_version' => SPEC_VERSION,
        'type' => 'Collection',
        'stac_extensions' => stac_extensions,
        'id' => id,
        'title' => title,
        'description' => description,
        'keywords' => keywords,
        'license' => license,
        'providers' => providers,
        'extent' => extent,
        'assets' => assets,
        'summaries' => summaries,
        'links' => links.map(&:to_h),
      }.merge(extra_fields).compact
    end

    def to_json(...)
      to_h.to_json(...)
    end
  end
end
