# stac-ruby

A Ruby library for working with [SpatioTemporal Asset Catalog (STAC)](https://stacspec.org/).\
See [satc-client-ruby](https://github.com/sankichi92/stac-client-ruby) for [STAC API](https://github.com/radiantearth/stac-api-spec) client.

This gem's implementation refers to [PySTAC](https://github.com/stac-utils/pystac).

### STAC Spec Version Support

v1.0.0

### STAC Extension Support

- [Electro-Optical](https://github.com/stac-extensions/eo) v1.0.0
- [Projection](https://github.com/stac-extensions/projection) v1.0.0
- [Scientific Citation](https://github.com/stac-extensions/scientific) v1.0.0
- [View Geometry](https://github.com/stac-extensions/view) v1.0.0

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add stac

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install stac

## Getting Started

```ruby
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
```

## Documentation

https://sankichi92.github.io/stac-ruby/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sankichi92/stac-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sankichi92/stac-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the STAC Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sankichi92/stac/blob/main/CODE_OF_CONDUCT.md).
