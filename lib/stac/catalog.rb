# frozen_string_literal: true

require 'json'
require_relative 'errors'
require_relative 'link'
require_relative 'spec_version'

module STAC
  # Represents STAC catalog.
  #
  # Spec: https://github.com/radiantearth/stac-spec/tree/master/catalog-spec
  class Catalog
    class << self
      def from_file(path)
        json = File.read(path)
        hash = JSON.parse(json)
        from_hash(hash)
      end

      def from_hash(hash)
        raise TypeError, "type field is not 'Catalog': #{hash['type']}" if hash.fetch('type') != 'Catalog'

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        transformed[:links] = transformed.fetch(:links).map { |link| Link.from_hash(link) }
        new(**transformed)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :id, :description, :links, :title, :stac_extensions, :extra

    def initialize(id:, description:, links:, title: nil, stac_extensions: nil, **extra)
      @id = id
      @description = description
      @links = links
      @title = title
      @stac_extensions = stac_extensions
      @extra = extra.transform_keys(&:to_s)
    end

    def to_h
      {
        'type' => 'Catalog',
        'stac_version' => SPEC_VERSION,
        'stac_extensions' => stac_extensions,
        'id' => id,
        'title' => title,
        'description' => description,
        'links' => links.map(&:to_h),
      }.merge(extra).compact
    end

    def to_json(...)
      to_h.to_json(...)
    end
  end
end
