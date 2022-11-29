# frozen_string_literal: true

require_relative '../extension'
require_relative '../item'

module STAC
  module Extensions
    # Utilities for View Geometry extension.
    #
    # View Geometry Extension Specification: https://github.com/stac-extensions/scientific/
    module ViewGeometry
      extend Extension

      self.identifier = 'https://stac-extensions.github.io/view/v1.0.0/schema.json'
      self.scope = [Item]

      module Properties # rubocop:disable Style/Documentation
        attr_reader :extra

        %w[
          view:off_nadir view:incidence_angle view:azimuth view:sun_azimuth view:sun_elevation
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
    end
  end
end
