# frozen_string_literal: true

require_relative 'errors'
require_relative 'stac_object'

module STAC
  # Represents STAC catalog.
  #
  # Spec: https://github.com/radiantearth/stac-spec/tree/master/catalog-spec
  class Catalog < STACObject
    self.type = 'Catalog'

    attr_accessor :description, :title

    def initialize(id:, description:, links:, title: nil, stac_extensions: nil, **extra)
      super(id: id, links: links, stac_extensions: stac_extensions, **extra)
      @description = description
      @title = title
    end

    # Serializes self to a Hash.
    def to_h
      super.merge(
        {
          'title' => title,
          'description' => description,
        }.compact,
      )
    end

    # Returns Catalog/Collection objects from rel="child" links of this catalog.
    def children
      links.select { |link| link.rel == 'child' }.lazy.map(&:target)
    end

    # Returns child Collections of this catalog.
    def collections
      children.select { |child| child.type == 'Collection' }
    end

    # Returns the child Catalog/Collection with the given ID if it exists.
    def find_child(id)
      children.find { |child| child.id == id }
    end

    # Returns Item objects from rel="item" links of this catalog.
    def items
      links.select { |link| link.rel == 'item' }.lazy.map(&:target)
    end

    # Returns all Items from this catalog and its child catalogs recursively.
    def all_items
      # The last `.lazy` is not necessary with Ruby 3.1.
      # But with Ruby 3.0, it is necessary because Enumerator::Lazy#chain returns Enumerator::Chain
      # and RBS type check fails.
      items.chain(children.flat_map(&:items)).lazy
    end
  end
end
