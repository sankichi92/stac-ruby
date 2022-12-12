# frozen_string_literal: true

require 'pathname'
require 'json'
require 'uri'
require_relative 'errors'

module STAC
  # Class to write a hash as JSON on a file.
  class FileWriter
    attr_reader :json_options

    def initialize(**json_options)
      @json_options = json_options
    end

    # Creates a file on `dest` with the given hash as JSON.
    def write(hash, dest:)
      dest_uri = URI.parse(dest)
      path = if dest_uri.relative?
               dest
             elsif dest_uri.is_a?(URI::File)
               dest_uri.path.to_s
             else
               raise NotSupportedURISchemeError, "not supported URI scheme: #{dest}"
             end

      pathname = Pathname(path)
      pathname.dirname.mkpath
      pathname.write(JSON.generate(hash, json_options))
    end
  end
end
