# frozen_string_literal: true

require_relative 'errors'

module STAC
  # Raised when an extension module does have identifier.
  class ExtensionWithoutIdentifierError < Error; end

  # \Extension modules must extend this module.
  module Extension
    # Returns extension id for `stac_extensions` field.
    #
    # When given an argument, sets the given value as its identifier.
    def identifier(identifier = nil)
      # @type self: Module
      if identifier.nil?
        @identifier or raise ExtensionWithoutIdentifierError, "extension module must be set identifier: #{name}"
      else
        @identifier = identifier
      end
    end

    # Returns extendable \STAC Object classes.
    #
    # When given arguments, sets the given values as its scope.
    def scope(*scope)
      if scope.empty?
        @scope ||= []
      else
        @scope = scope
      end
    end
  end
end
