# frozen_string_literal: true

module STAC
  class Provider
    class << self
      def from_hash(hash)
        new(
          name: hash.fetch('name'),
          description: hash['description'],
          roles: hash['roles'],
          url: hash['url'],
        )
      end
    end

    attr_accessor :name, :description, :roles, :url

    def initialize(name:, description: nil, roles: nil, url: nil)
      @name = name
      @description = description
      @roles = roles
      @url = url
    end

    def to_h
      {
        'name' => name,
        'description' => description,
        'roles' => roles,
        'url' => url,
      }.compact
    end
  end
end
