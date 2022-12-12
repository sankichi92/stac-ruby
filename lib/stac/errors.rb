# frozen_string_literal: true

module STAC
  # Base error class for this gem.
  class Error < StandardError; end

  # Raised when unexpected "type" field was given.
  class TypeError < Error; end

  # Raised when URL with not supported scheme was given.
  class NotSupportedURISchemeError < Error; end
end
