# frozen_string_literal: true

module STAC
  class Error < StandardError; end

  class TypeError < Error; end

  class HTTPError < Error; end
end
