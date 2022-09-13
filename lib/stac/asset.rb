# frozen_string_literal: true

module STAC
  class Asset
    class << self
      def from_hash(hash)
        new(
          href: hash.fetch('href'),
          title: hash['title'],
          description: hash['description'],
          type: hash['type'],
          roles: hash['roles'],
        )
      end
    end

    attr_accessor :href, :title, :description, :type, :roles

    def initialize(href:, title: nil, description: nil, type: nil, roles: nil)
      @href = href
      @title = title
      @description = description
      @type = type
      @roles = roles
    end

    def to_h
      {
        'href' => href,
        'title' => title,
        'description' => description,
        'type' => type,
        'roles' => roles,
      }.compact
    end
  end
end
