# frozen_string_literal: true

require 'open-uri'
require_relative 'errors'
require_relative 'version'

module STAC
  # Simple HTTP Client using OpenURI.
  class DefaultHTTPClient
    attr_reader :options

    def initialize(options = { 'User-Agent' => "stac-ruby v#{VERSION}" })
      @options = options
    end

    # Makes a HTTP request and returns the response body as String.
    #
    # Raises STAC::HTTPError when the response status is not 2XX.
    def get(uri)
      uri.read(options)
    rescue OpenURI::HTTPError => e
      raise HTTPError, e.message
    end
  end
end
