# frozen_string_literal: true

require 'pathname'
require_relative 'errors'
require_relative 'stac_object'

module STAC
  # Represents \STAC catalog.
  #
  # \STAC \Catalog Specification: https://github.com/radiantearth/stac-spec/tree/master/catalog-spec
  class Catalog < STAC::STACObject
    @type = 'Catalog'

    attr_accessor :id, :description, :title

    def initialize(id:, description:, links: [], title: nil, stac_extensions: [], **extra)
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
      child_links.lazy.map(&:target)
    end

    def all_children # :nodoc:
      children.chain(children.flat_map(&:all_children)).lazy
    end

    # Filters only collections from #children.
    def collections
      children.select { |child| child.type == 'Collection' }
    end

    # Returns all collections from this catalog and its child catalogs/collections recursively.
    def all_collections
      # The last `.lazy` is not necessary with Ruby 3.1.
      # But with Ruby 3.0, it is necessary because Enumerator::Lazy#chain returns Enumerator::Chain
      # and RBS type check fails.
      collections.chain(children.flat_map(&:all_collections)).lazy
    end

    # Returns the child catalog/collection with the given ID if it exists.
    #
    # With option `recusive: true`, it will traverse all child catalogs/collections recursively.
    def find_child(id, recursive: false)
      (recursive ? all_children : children).find { |child| child.id == id }
    end

    # Returns item objects from rel="item" links of this catalog.
    def items
      item_links.lazy.map(&:target)
    end

    # Returns all items from this catalog and its child catalogs/collections recursively.
    def all_items
      # The last `.lazy` is not necessary with Ruby 3.1.
      # But with Ruby 3.0, it is necessary because Enumerator::Lazy#chain returns Enumerator::Chain
      # and RBS type check fails.
      items.chain(children.flat_map(&:all_items)).lazy
    end

    # Returns the item with the given ID if it exists.
    #
    # With option `recursive: true`, it will traverse all child catalogs/collections recursively.
    def find_item(id, recursive: false)
      (recursive ? all_items : items).find { |item| item.id == id }
    end

    # Adds a rel="child" link to self and adds "self", "root", and "parent" links to the child catalog.
    def add_child(catalog, href: "#{catalog.id}/#{catalog.type.downcase}.json", title: catalog.title)
      if (base = self_href)
        catalog.self_href = Pathname(base).dirname.join(href).to_s
      end
      catalog.root = root
      catalog.parent = self
      add_link(catalog, rel: 'child', type: 'application/json', title: title)
    end

    # Adds a rel="item" link to self and adds "self", "root", and "parent" links to the given item.
    def add_item(item, href: "#{item.id}.json", title: item.properties.title)
      if (base = self_href)
        item.self_href = Pathname(base).dirname.join(href).to_s
      end
      item.root = root
      item.parent = self
      add_link(item, rel: 'item', type: 'application/geo+json', title: title)
    end

    # Exports this catalog and all its children and items to the specified dir or each self href.
    def export(dest_dir = nil, writer: FileWriter.new)
      dest_pathname = Pathname(dest_dir) if dest_dir
      self_dest = dest_pathname.join(File.basename(self_href!)).to_s if dest_pathname
      save(self_dest, writer: writer)

      item_links.select(&:resolved?).each do |item_link|
        item_dest = dest_pathname.join(item_link.relative_href!).to_s if dest_pathname
        item_link.target.save(item_dest, writer: writer)
      end

      child_links.select(&:resolved?).each do |child_link|
        child_dest_dir = dest_pathname.join(child_link.relative_href!).dirname.to_s if dest_pathname
        child_link.target.export(child_dest_dir, writer: writer)
      end
    end

    private

    def child_links
      links.select { |link| link.rel == 'child' }
    end

    def item_links
      links.select { |link| link.rel == 'item' }
    end
  end
end
