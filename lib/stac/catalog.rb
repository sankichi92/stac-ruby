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
      # Deserializes a Catalog from a Hash.
      #
      # Raises
      # - STAC::TypeError when the value of `type` is not "Catalog"
      # - ArgumentError when a required field is missing
      def from_hash(hash)
        raise TypeError, "type field is not 'Catalog': #{hash['type']}" if hash.fetch('type') != 'Catalog'

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        transformed[:links] = transformed.fetch(:links).map { |link| Link.from_hash(link) }
        new(**transformed)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :id, :description, :title, :stac_extensions, :extra

    attr_reader :links

    def initialize(id:, description:, links:, title: nil, stac_extensions: nil, **extra)
      @id = id
      @description = description
      @links = []
      links.each do |link|
        add_link(link) # to set `owner`
      end
      @title = title
      @stac_extensions = stac_extensions
      @extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
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

    # Serializes self to a JSON string.
    def to_json(...)
      to_h.to_json(...)
    end

    # Adds a link with setting its `owner` as self.
    def add_link(link)
      link.owner = self
      links << link
    end

    # Reterns HREF of the rel="self" link.
    def self_href
      links.find { |link| link.rel == 'self' }&.href
    end

    # Adds a link with the give HREF as rel="self".
    #
    # When ref="self" links already exist, it removes them.
    def self_href=(absolute_href)
      self_link = Link.new(rel: 'self', href: absolute_href, type: 'application/json')
      links.reject! { |link| link.rel == 'self' }
      add_link(self_link)
    end

    # Returns Enumerable::Lazy of Collection objects from children.
    def collections
      children.select { |child| child.instance_of?(Collection) }
    end

    # Returns the child STAC object with the given ID.
    def child(id)
      children.find { |child| child.id == id }
    end

    private

    def children
      links.select { |link| link.rel == 'child' }.lazy.map(&:target)
    end
  end
end
