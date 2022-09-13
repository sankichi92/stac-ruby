# frozen_string_literal: true

module STAC
  class Provider
    class << self
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :name, :description, :roles, :url, :extra

    def initialize(name:, description: nil, roles: nil, url: nil, **extra)
      @name = name
      @description = description
      @roles = roles
      @url = url
      @extra = extra.transform_keys(&:to_s)
    end

    def to_h
      {
        'name' => name,
        'description' => description,
        'roles' => roles,
        'url' => url,
      }.merge(extra).compact
    end
  end
end
