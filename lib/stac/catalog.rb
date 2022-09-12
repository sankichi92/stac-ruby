# frozen_string_literal: true

require 'json'
require_relative 'errors'
require_relative 'link'
require_relative 'spec_version'

module STAC
  class Catalog
    class << self
      def from_file(path)
        json = File.read(path)
        hash = JSON.parse(json)
        from_hash(hash)
      end

      def from_hash(hash)
        raise TypeError, "type field is not 'Catalog': #{hash['type']}" if hash.fetch('type') != 'Catalog'

        new(
          id: hash.fetch('id'),
          description: hash.fetch('description'),
          links: hash.fetch('links').map { |link| Link.from_hash(link) },
          title: hash['title'],
          stac_extensions: hash['stac_extensions'],
          extra_fields: hash.except(*%w[type stac_version id description links title stac_extensions]),
        )
      rescue KeyError => e
        raise MissingRequiredFieldError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :id, :description, :links, :title, :stac_extensions, :extra_fields

    def initialize(id:, description:, links:, title: nil, stac_extensions: nil, extra_fields: {})
      @id = id
      @description = description
      @links = links
      @title = title
      @stac_extensions = stac_extensions
      @extra_fields = extra_fields
    end

    def to_h
      {
        'stac_version' => SPEC_VERSION,
        'type' => 'Catalog',
        'stac_extensions' => stac_extensions,
        'id' => id,
        'title' => title,
        'description' => description,
        'links' => links.map(&:to_h),
      }.merge(extra_fields).compact
    end

    def to_json(...)
      to_h.to_json(...)
    end
  end
end
