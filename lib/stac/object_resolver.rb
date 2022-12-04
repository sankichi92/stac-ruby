# frozen_string_literal: true

require 'json'
require_relative 'catalog'
require_relative 'collection'
require_relative 'errors'
require_relative 'item'

module STAC
  # Resolves a \STAC object from a URL.
  class ObjectResolver
    class << self
      # Resolvable classes. Default is Catalog, Collection and Item.
      attr_reader :resolvables
    end

    @resolvables = [Catalog, Collection, Item]

    attr_reader :http_client

    def initialize(http_client:)
      @http_client = http_client
    end

    # Reads a JSON from the given URL and returns a \STAC object resolved from it.
    #
    # Supports the following URL scheme:
    # - http
    # - https
    # - file
    #
    # Raises:
    # - STAC::UnknownURISchemeError when a URL with unsupported scheme was given
    # - STAC::TypeError when it could not resolve any \STAC objects
    def resolve(url)
      hash = read(url)
      klass = self.class.resolvables.find { |c| c.type == hash['type'] }
      raise TypeError, "unknown STAC object type: #{hash['type']}" unless klass

      object = klass.from_hash(hash)
      object.http_client = http_client
      object
    end

    private

    def read(url)
      uri = URI.parse(url)
      case uri
      when URI::HTTP
        http_client.get(uri)
      when URI::File
        str = File.read(uri.path.to_s)
        JSON.parse(str)
      else
        raise UnknownURISchemeError, "unknown URI scheme: #{url}"
      end
    end
  end
end
