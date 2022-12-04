# frozen_string_literal: true

require_relative '../extension'
require_relative '../item'

module STAC
  module Extensions
    # Utilities for Electro-Optical extension.
    #
    # Electro-Optical \Extension Specification: https://github.com/stac-extensions/eo/
    module ElectroOptical
      extend Extension

      identifier 'https://stac-extensions.github.io/eo/v1.0.0/schema.json'
      scope STAC::Item

      module Properties # rubocop:disable Style/Documentation
        attr_reader :extra

        def eo_bands
          extra.fetch('eo:bands', []).map { |band_hash| Band.new(band_hash) }
        end

        def eo_bands=(bands)
          extra['eo:bands'] = bands.map(&:to_h)
        end

        def eo_cloud_cover
          extra['eo:cloud_cover']
        end

        def eo_cloud_cover=(cloud_cover)
          extra['eo:cloud_cover'] = cloud_cover
        end
      end

      module Asset
        include Properties
      end

      # Represents \Band object of Electro-Optical extension.
      class Band
        attr_reader :raw_hash # :nodoc:

        def initialize(raw_hash)
          @raw_hash = raw_hash
        end

        def to_h
          raw_hash
        end

        %i[name common_name description center_wavelength full_width_half_max].each do |field|
          define_method(field) do
            # @type self: Band
            raw_hash[field.to_s]
          end

          define_method("#{field}=") do |value|
            # @type self: Band
            raw_hash[field.to_s] = value
          end
        end
      end
    end
  end
end
