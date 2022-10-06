# frozen_string_literal: true

require 'pathname'
require 'uri'
require_relative 'errors'
require_relative 'object_resolver'

module STAC
  # Represents STAC link object, which describes a relationship with another entity.
  class Link
    class << self
      # Deserializes a Link from a Hash.
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :rel, :href, :type, :title, :extra

    # Owner object of this link.
    attr_accessor :owner

    attr_writer :resolver # :nodoc:

    def initialize(rel:, href:, type: nil, title: nil, **extra)
      @rel = rel
      @href = href
      @type = type
      @title = title
      @extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
    def to_h
      {
        'rel' => rel,
        'href' => href,
        'type' => type,
        'title' => title,
      }.merge(extra).compact
    end

    # Returns the absolute HREF for this link.
    #
    # When it could not assemble the absolute HREF, it returns nil.
    def absolute_href
      if URI(href).absolute?
        href
      elsif (base_href = owner&.self_href)
        Pathname(base_href).dirname.join(href).to_s
      end
    end

    # Returns a STAC object resolved from HREF.
    #
    # When it could not assemble the absolute HREF, it returns nil.
    def target
      @target ||= if (url = absolute_href)
                    object = resolver.resolve(url)
                    object.self_href = url
                    object
                  end
    end

    private

    def resolver
      @resolver ||= ObjectResolver.new
    end
  end
end
