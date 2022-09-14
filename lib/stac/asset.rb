# frozen_string_literal: true

module STAC
  # Represents STAC asset object, which contains a link to data associated with an Item or Collection that can be
  # downloaded or streamed.
  class Asset
    class << self
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :href, :title, :description, :type, :roles, :extra

    def initialize(href:, title: nil, description: nil, type: nil, roles: nil, **extra)
      @href = href
      @title = title
      @description = description
      @type = type
      @roles = roles
      @extra = extra.transform_keys(&:to_s)
    end

    def to_h
      {
        'href' => href,
        'title' => title,
        'description' => description,
        'type' => type,
        'roles' => roles,
      }.merge(extra).compact
    end
  end
end
