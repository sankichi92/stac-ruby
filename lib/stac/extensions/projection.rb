# frozen_string_literal: true

require_relative '../extension'
require_relative '../item'

module STAC
  module Extensions
    # Utilities for \Projection extension.
    #
    # \Projection \Extension Specification: https://github.com/stac-extensions/projection/
    module Projection
      extend Extension

      identifier 'https://stac-extensions.github.io/projection/v1.0.0/schema.json'
      scope STAC::Item

      module Properties # rubocop:disable Style/Documentation
        attr_reader :extra

        %w[
          proj:epsg proj:wkt2 proj:projjson proj:geometry proj:bbox proj:centroid proj:shape proj:transform
        ].each do |field|
          method_name = field.sub(':', '_')

          define_method(method_name) do
            # @type self: Properties
            extra[field]
          end

          define_method("#{method_name}=") do |value|
            # @type self: Properties
            extra[field] = value
          end
        end
      end

      module Asset
        include Properties
      end
    end
  end
end
