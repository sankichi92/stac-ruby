# frozen_string_literal: true

module STAC
  # Represents STAC link object, which describes a relationship with another entity.
  class Link
    class << self
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :rel, :href, :type, :title, :extra

    def initialize(rel:, href:, type: nil, title: nil, **extra)
      @rel = rel
      @href = href
      @type = type
      @title = title
      @extra = extra.transform_keys(&:to_s)
    end

    def to_h
      {
        'rel' => rel,
        'href' => href,
        'type' => type,
        'title' => title,
      }.merge(extra).compact
    end
  end
end
