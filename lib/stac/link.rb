# frozen_string_literal: true

module STAC
  class Link
    class << self
      def from_hash(hash)
        new(
          rel: hash['rel'],
          href: hash['href'],
          type: hash['type'],
          title: hash['title'],
        )
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
