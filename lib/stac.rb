# frozen_string_literal: true

require_relative 'stac/object_resolver'
require_relative 'stac/version'

# Gem namespace.
#
# Provides some utility methods.
module STAC
  class << self
    # Returns a \STAC object resolved from the given file path.
    def from_file(path)
      from_url("file://#{File.expand_path(path)}")
    end

    # Returns a \STAC object resolved from the given URL.
    #
    # When the resolved object does not have rel="self" link, adds a rel="self" link with the give url.
    def from_url(url, resolver: ObjectResolver.new)
      object = resolver.resolve(url)
      object.self_href = url unless object.self_href
      object
    end
  end
end
