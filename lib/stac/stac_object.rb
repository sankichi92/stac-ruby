# frozen_string_literal: true

require 'json'
require_relative 'errors'
require_relative 'link'
require_relative 'spec_version'

module STAC
  # Base class for \STAC objects (i.e. Catalog, Collection and Item).
  class STACObject
    class << self
      attr_accessor :type # :nodoc:

      # Base method to deserialize shared fields from a Hash.
      #
      # Raises ArgumentError when any required fields are missing.
      def from_hash(hash)
        raise TypeError, "type field is not '#{type}': #{hash['type']}" if hash.fetch('type') != type

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        transformed[:links] = transformed.fetch(:links).map { |link| Link.from_hash(link) }
        new(**transformed)
      rescue KeyError => e
        raise ArgumentError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :stac_extensions, :extra

    # HTTP Client to fetch objects from HTTP HREF links.
    attr_accessor :http_client

    attr_reader :links

    def initialize(links:, stac_extensions: nil, **extra)
      @links = []
      links.each do |link|
        add_link(link) # to set `owner`
      end
      @stac_extensions = stac_extensions
      @extra = extra.transform_keys(&:to_s)
      @http_client = STAC.default_http_client
    end

    def type
      self.class.type
    end

    # Serializes self to a Hash.
    def to_h
      {
        'type' => type,
        'stac_version' => SPEC_VERSION,
        'stac_extensions' => stac_extensions,
        'links' => links.map(&:to_h),
      }.merge(extra).compact
    end

    # Serializes self to a JSON string.
    def to_json(...)
      to_h.to_json(...)
    end

    # Adds a link with setting Link#owner as self.
    def add_link(link)
      link.owner = self
      links << link
    end

    # Reterns HREF of the rel="self" link.
    def self_href
      find_link(rel: 'self')&.href
    end

    # Adds a link with the give HREF as rel="self".
    #
    # When any ref="self" links already exist, removes them.
    def self_href=(absolute_href)
      self_link = Link.new(rel: 'self', href: absolute_href, type: 'application/json')
      remove_link(rel: 'self')
      add_link(self_link)
    end

    private

    def find_link(rel:)
      links.find { |link| link.rel == rel }
    end

    def remove_link(rel:)
      links.reject! { |link| link.rel == rel }
    end
  end
end
