# frozen_string_literal: true

module STAC
  class Link
    class << self
      def from_hash(hash)
        new(
          rel: hash.fetch('rel'),
          href: hash.fetch('href'),
          type: hash['type'],
          title: hash['title'],
        )
      rescue KeyError => e
        raise MissingRequiredFieldError, "required field not found: #{e.key}"
      end
    end

    attr_accessor :rel, :href, :type, :title

    def initialize(rel:, href:, type: nil, title: nil)
      @rel = rel
      @href = href
      @type = type
      @title = title
    end

    def to_h
      {
        'rel' => rel,
        'href' => href,
        'type' => type,
        'title' => title,
      }.compact
    end
  end
end
