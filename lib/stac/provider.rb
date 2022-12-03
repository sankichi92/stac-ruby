# frozen_string_literal: true

require_relative 'hash_like'

module STAC
  # Represents \STAC provider object, which provides information about a provider.
  #
  # Specicication: https://github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md#provider-object
  class Provider
    include HashLike

    class << self
      # Deserializes a Provider from a Hash.
      def from_hash(hash)
        new(**hash.transform_keys(&:to_sym))
      end
    end

    attr_accessor :name, :description, :roles, :url

    def initialize(name:, description: nil, roles: nil, url: nil, **extra)
      @name = name
      @description = description
      @roles = roles
      @url = url
      @extra = extra.transform_keys(&:to_s)
    end

    # Serializes self to a Hash.
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
