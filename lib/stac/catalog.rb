# frozen_string_literal: true

require_relative 'errors'
require_relative 'stac_object'

module STAC
  # Represents \STAC catalog.
  #
  # \STAC \Catalog Specification: https://github.com/radiantearth/stac-spec/tree/master/catalog-spec
  class Catalog < STAC::STACObject
    self.type = 'Catalog'

    attr_accessor :id, :description, :title

    def initialize(id:, description:, links:, title: nil, stac_extensions: [], **extra)
      @id = id
      @description = description
      @title = title
      super(links: links, stac_extensions: stac_extensions, **extra)
    end

    # Serializes self to a Hash.
    def to_h
      super.merge(
        {
          'id' => id,
          'title' => title,
          'description' => description,
        }.compact,
      )
    end

    # Returns catalog/collection objects from rel="child" links of this catalog.
    def children
      links.select { |link| link.rel == 'child' }.lazy.map(&:target)
    end

    # Filters only collections from #children.
    def collections
      children.select { |child| child.type == 'Collection' }
    end

    # Returns the child catalog/collection with the given ID if it exists.
    #
    # With option `recusive: true`, it will traverse all child catalogs/collections recursively.
    def find_child(id, recursive: false)
      targets = recursive ? children.chain(children.flat_map(&:children)) : children
      targets.find { |child| child.id == id }
    end

    # Returns item objects from rel="item" links of this catalog.
    def items
      links.select { |link| link.rel == 'item' }.lazy.map(&:target)
    end

    # Returns all items from this catalog and its child catalogs/collections recursively.
    def all_items
      # The last `.lazy` is not necessary with Ruby 3.1.
      # But with Ruby 3.0, it is necessary because Enumerator::Lazy#chain returns Enumerator::Chain
      # and RBS type check fails.
      items.chain(children.flat_map(&:items)).lazy
    end

    # Returns the item with the given ID if it exists.
    #
    # With option `recursive: true`, it will traverse all child catalogs/collections recursively.
    def find_item(id, recursive: false)
      (recursive ? all_items : items).find { |item| item.id == id }
    end
  end
end
