# frozen_string_literal: true

require_relative '../extension'
require_relative '../item'
require_relative '../collection'

module STAC
  module Extensions
    # Utilities for Scientific Citation extension.
    #
    # Scientific Citation \Extension Specification: https://github.com/stac-extensions/scientific/
    module ScientificCitation
      extend Extension

      identifier 'https://stac-extensions.github.io/scientific/v1.0.0/schema.json'
      scope STAC::Item, STAC::Collection

      module Properties # rubocop:disable Style/Documentation
        attr_reader :extra

        def sci_doi
          extra['sci:doi']
        end

        def sci_doi=(doi)
          extra['sci:doi'] = doi
        end

        def sci_citation
          extra['sci:citation']
        end

        def sci_citation=(citation)
          extra['sci:citation'] = citation
        end

        def sci_publications
          extra.fetch('sci:publications', []).map { |hash| Publication.new(hash) }
        end

        def sci_publications=(publications)
          extra['sci:publications'] = publications.map(&:to_h)
        end
      end

      module Asset
        include Properties
      end

      module Collection
        include Properties
      end

      # Represents \Publication object of Scientific Citation extension.
      class Publication
        # :nodoc:
        attr_reader :raw_hash

        def initialize(raw_hash)
          @raw_hash = raw_hash
        end

        def to_h
          raw_hash
        end

        def doi
          raw_hash['doi']
        end

        def doi=(doi)
          raw_hash['doi'] = doi
        end

        def citation
          raw_hash['citation']
        end

        def catation=(citation)
          raw_hash['citation'] = citation
        end
      end
    end
  end
end
