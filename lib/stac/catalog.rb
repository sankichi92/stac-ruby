# frozen_string_literal: true

require "json"
require_relative "errors"
require_relative "spec_version"

module STAC
  class Catalog
    class << self
      def from_file(path)
        json = File.read(path)
        hash = JSON.parse(json)
        from_hash(hash)
      end

      def from_hash(hash)
        hash = hash.dup

        if (type = hash.delete("type")) != "Catalog"
          raise STACTypeError, "Type value is not \"Catalog\": \"#{type}\""
        end

        new(
          id: hash.delete("id"),
          title: hash.delete("title"),
          description: hash.delete("description"),
          links: hash.delete("links"),
          stac_extensions: hash.delete("stac_extensions"),
          extra_fields: hash.except("stac_version")
        )
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
        "stac_version" => SPEC_VERSION,
        "type" => "Catalog",
        "stac_extensions" => stac_extensions,
        "id" => id,
        "title" => title,
        "description" => description,
        "links" => links
      }.merge(extra_fields).compact
    end

    def to_json(...)
      to_h.to_json(...)
    end
  end
end
