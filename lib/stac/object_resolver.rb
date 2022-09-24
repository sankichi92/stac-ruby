# frozen_string_literal: true

require 'json'
require_relative 'default_http_client'
require_relative 'errors'

module STAC
  # Resolves a STAC object from a URL.
  class ObjectResolver
    class << self
      attr_writer :default_http_client

      def default_http_client
        @default_http_client ||= DefaultHTTPClient.new
      end
    end

    attr_reader :http_client

    def initialize(http_client: self.class.default_http_client)
      @http_client = http_client
    end

    # Reads a JSON from the given URL and returns a STAC object resolved from it.
    #
    # Supports the following URL scheme:
    # - http
    # - https
    # - file
    #
    # Raises:
    # - STAC::UnknownURISchemeError when a URL with unsupported scheme was given
    # - STAC::TypeError when it could not resolve any STAC objects
    def resolve(url)
      str = read(url)
      hash = JSON.parse(str)
      klass = begin
        STAC.const_get(hash.fetch('type', nil).to_s)
      rescue NameError
        raise TypeError, "unknown STAC object type: #{hash['type']}"
      end
      klass.from_hash(hash)
    end

    private

    def read(url)
      uri = URI.parse(url)
      case uri
      when URI::HTTP
        http_client.get(uri)
      when URI::File
        File.read(uri.path.to_s)
      else
        raise UnknownURISchemeError, "unknown URI scheme: #{url}"
      end
    end
  end
end
