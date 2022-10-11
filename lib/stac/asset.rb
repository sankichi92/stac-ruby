# frozen_string_literal: true

require_relative 'common_metadata'

module STAC
  # Represents \STAC asset object, which contains a link to data associated with an Item or Collection that can be
  # downloaded or streamed.
  class Asset
    include CommonMetadata

    class << self
      # Deserializes an Asset from a Hash.
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :href, :title, :description, :type, :roles

    def initialize(href:, title: nil, description: nil, type: nil, roles: nil, **extra)
      @href = href
      @title = title
      @description = description
      @type = type
      @roles = roles
      self.extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
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
