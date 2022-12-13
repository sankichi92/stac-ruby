# frozen_string_literal: true

require 'pathname'
require 'json'
require 'uri'
require_relative 'errors'

module STAC
  # Class to write a hash as JSON on a file.
  class FileWriter
    def initialize(hash_to_json: ->(hash) { JSON.generate(hash) })
      @hash_to_json = hash_to_json
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
      pathname.write(@hash_to_json.call(hash))
    end
  end
end
