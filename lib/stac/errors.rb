# frozen_string_literal: true

module STAC
  # Base error class for this gem.
  class Error < StandardError; end

  # Raised when unexpected "type" field was given.
  class TypeError < Error; end

  # Raised when URL with unsupported scheme was given.
  class UnknownURISchemeError < Error; end

  # Raised when a HTTP request failed.
  class HTTPError < Error; end

  # Raised when an extension module does have identifier.
  class ExtensionWithoutIdentifierError < Error; end
end
