# frozen_string_literal: true

require_relative 'stac/object_resolver'
require_relative 'stac/simple_http_client'
require_relative 'stac/stac_object'
require_relative 'stac/extensions/electro_optical'
require_relative 'stac/extensions/projection'
require_relative 'stac/extensions/scientific_citation'
require_relative 'stac/extensions/view_geometry'
require_relative 'stac/version'

# Gem namespace.
#
# Provides some utility methods.
module STAC
  class << self
    attr_accessor :default_http_client

    # Returns a \STAC object resolved from the given file path.
    def from_file(path)
      from_url("file://#{File.expand_path(path)}")
    end

    # Returns a \STAC object resolved from the given URL.
    #
    # When the resolved object does not have rel="self" link, adds a rel="self" link with the give url.
    def from_url(url, http_client: default_http_client)
      object = ObjectResolver.new(http_client: http_client).resolve(url)
      object.self_href = url unless object.self_href
      object
    end
  end

  self.default_http_client = SimpleHTTPClient.new

  STACObject
    .add_extendable(Extensions::ElectroOptical)
    .add_extendable(Extensions::Projection)
    .add_extendable(Extensions::ScientificCitation)
    .add_extendable(Extensions::ViewGeometry)
end
