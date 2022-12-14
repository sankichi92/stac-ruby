# frozen_string_literal: true

require 'json'
require 'open-uri'
require_relative 'errors'
require_relative 'version'

module STAC
  # Raised when a HTTP request failed.
  class HTTPError < Error; end

  # Simple HTTP Client using OpenURI.
  class SimpleHTTPClient
    attr_reader :options

    def initialize(options = { 'User-Agent' => "stac-ruby v#{VERSION}" })
      @options = options
    end

    # Makes a HTTP request and returns the responded JSON as Hash.
    #
    # Raises STAC::HTTPError when the response status is not 2XX.
    def get(url)
      body = URI(url).read(options)
      JSON.parse(body)
    rescue OpenURI::HTTPError => e
      raise HTTPError, e.message
    end
  end
end
