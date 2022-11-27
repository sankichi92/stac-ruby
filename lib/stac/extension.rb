# frozen_string_literal: true

module STAC
  # Extension modules must extend this module.
  module Extension
    # Extension ID for `stac_extensions` field.
    attr_accessor :identifier

    # Extendable \STAC Object classes.
    attr_accessor :scope
  end
end
