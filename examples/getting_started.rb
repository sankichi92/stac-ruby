# frozen_string_literal: true

require 'stac'

# Reading a Catalog
# ================

# Read the example catalog.
catalog = STAC.from_url('https://raw.githubusercontent.com/radiantearth/stac-spec/master/examples/catalog.json')

# Print some basic metadata.
puts "ID: #{catalog.id}"
puts "Title: #{catalog.title}"
puts "Description: #{catalog.description}"

# Crawling Child Catalogs/Collections
# ================

# List Collections in the Catalog.
puts 'Collections IDs:'
catalog.collections.each do |collection|
  puts "- #{collection.id}"
end

# Get a child Catalog or Collection by ID.
_collection = catalog.find_child('extensions-collection')

# Crawling Items
# ================

# List all items associated with the Catalog recursively.
puts 'Item IDs:'
catalog.all_items.each do |item|
  puts "- #{item.id}"
end

# Item Metadata
# ================

# Get an Item by ID.
item = catalog.find_item('CS3-20160503_132131_08')

# Print core Item metadeata.
puts 'geometry:'
p item.geometry
puts 'bbox:'
p item.bbox
puts 'datetime:'
p item.datetime
puts 'collection_id:'
p item.collection_id

# Get actual Collection instance instead of ID.
_collection = item.collection

# Print common metadata.
puts "instruments: #{item.properties.instruments}"
puts "platform: #{item.properties.platform}"
puts "gsd: #{item.properties.gsd}"
