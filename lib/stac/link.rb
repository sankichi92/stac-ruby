# frozen_string_literal: true

require 'pathname'
require 'uri'
require_relative 'errors'
require_relative 'hash_like'

module STAC
  # Raised when a link does not have href or owner.
  class LinkHrefError < Error
    attr_reader :link

    def initialize(msg = nil, link:)
      super(msg)
      @link = link
    end
  end

  # Represents \STAC link object, which describes a relationship with another entity.
  class Link
    include HashLike

    class << self
      # Deserializes a Link from a Hash.
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :rel, :type, :title

    attr_writer :href

    # Owner object of this link.
    attr_accessor :owner

    def initialize(target = nil, rel:, href:, type: nil, title: nil, **extra)
      @target = target
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

    # Determines if the link's target is a resolved STACObject.
    def resolved?
      !@target.nil?
    end

    def href
      @href || @target&.self_href
    end

    # Returns the absolute HREF for this link.
    def absolute_href
      if URI(href!).absolute?
        href!
      elsif (base_href = owner&.self_href)
        Pathname(base_href).dirname.join(href!).to_s
      end
    end

    # Returns the relative HREF for this link.
    def relative_href
      if URI(href!).relative?
        href!
      elsif (base_href = owner&.self_href)
        Pathname(href!).relative_path_from(Pathname(base_href).dirname).to_s
      end
    end

    # Returns a \STAC object resolved from HREF.
    #
    # When it could not assemble the absolute HREF, it returns nil.
    def target(http_client: owner&.http_client || STAC.default_http_client)
      @target ||= if (url = absolute_href)
                    object = ObjectResolver.new(http_client: http_client).resolve(url)
                    object.self_href = url
                    object
                  end
    end

    def href! # :nodoc:
      href or raise LinkHrefError.new('href is nil', link: self)
    end

    def absolute_href! # :nodoc:
      absolute_href or raise LinkHrefError.new('could not assemble absolute href', link: self)
    end

    def relative_href! # :nodoc:
      relative_href or raise LinkHrefError.new('could not assemble relative href', link: self)
    end
  end
end
