# Getting Started

- [Reading STAC Objects](#reading-stac-objects)
- [STAC Object Classes](#stac-object-classes)
  - [STAC::Catalog](#staccatalog)
    - [Crawling Catalog Links](#crawling-catalog-links)
  - [STAC::Collection](#staccollection)
  - [STAC::Item](#stacitem)
    - [Common Metadata](#common-metadata)
- [Extensions](#extensions)
  - [Adding Extensions](#adding-extensions)
- [Using Custom HTTP Client](#using-custom-http-client)

## Reading STAC Objects

You can read any STAC objects from URL by `STAC.from_url`:

```ruby
catalog = STAC.from_url('https://raw.githubusercontent.com/radiantearth/stac-spec/master/examples/catalog.json')
catalog.class #=> STAC::Catalog
catalog.type #=> "Catalog"

collection = STAC.from_url('https://raw.githubusercontent.com/radiantearth/stac-spec/master/examples/collection.json')
collection.class #=> STAC::Collection
collection.type #=> "Collection"

item = STAC.from_item('https://raw.githubusercontent.com/radiantearth/stac-spec/master/examples/core-item.json')
item.class #=> STAC::Item
item.type #=> "Feature"
```

Also, from a local file by `STAC.from_file`:

```ruby
catalog = STAC.from_file('/path/to/local/catalog.json')
collection = STAC.from_file('/path/to/local/collection.json')
item = STAC.from_file('/path/to/local/item.json')
```

## STAC Object Classes

There are 3 core STAC object classes: `STAC::Catalog`, `STAC::Collection`, and `STAC::Item`.

They have a class method `from_hash(hash)`, which returns its instance converted from the given Hash.

```ruby
catalog = STAC::Catalog.from_hash(
  {
    'stac_version' => '1.0.0',
    'type' => 'Catalog',
    'id' => '20201211_223832_CS2',
    'description' => 'A simple catalog example',
    'links' => [],
  }
)
```

And they have the following instance methods in common:

- `extra: -> Hash[String, untyped]` returns extra fields that do not belong to the core specification like STAC extensions fields
- `to_h: -> Hash[String, untyped]`
- `to_json: -> String`
- `deep_dup: -> self` returns a deep copy of self.
- `stac_extensions: -> Array[String]`
- `add_extension: (String extension_id) -> self | (Module extension) -> self` (see [Extensions](#extensions))
- `links: -> Array[STAC::Link]`
- `find_link: (rel: String, ?type: String?) -> STAC::Link?`
- `add_link: (rel: String, href: String, ?type: String?, ?title: String?) -> self`
- `self_href: -> String?` returns rel="self" link's href value
- `self_href=: (String absolute_href) -> void` adds rel="self" link with the given href

### STAC::Catalog

`STAC::Catalog` has the following attributes:

- `attr_accessor id: String`
- `attr_accessor description: String`
- `attr_accessor title: String?`

```ruby
catalog.id = 'awesome_catalog'
catalog.id #=> "awesome_catalog"
```

See [STAC Catalog Specification](https://github.com/radiantearth/stac-spec/blob/master/catalog-spec/catalog-spec.md) for the details.

#### Crawling Catalog Links

`STAC::Catalog` also has methods to crawl its `links`:

- `children: -> Enumerator::Lazy[Catalog | Collection, void]` returns catalog/collection objects from rel="child" links
- `collections: -> Enumerator::Lazy[Collection, void]` filters only collections from #children
- `all_collections: -> Enumerator::Lazy[Catalog | Collection, void]` returns all collections from the catalog and its children recursively
- `items: -> Enumerator::Lazy[Item, void]` returns item objects from rel="items" links
- `all_items: -> Enumerator::Lazy[Item, void]` returns all items from the catalog and its children recursively
- `find_child: (String id, ?recursive: bool) -> (Catalog | Collection)?`
- `find_item: (String id, ?recursive: bool) -> Item?`

Note that the first 5 methods return [`Enumerator::Lazy`](https://rubyapi.org/3.1/o/enumerator/lazy).
This is to prevent making a large number of HTTP requests when calling the methods.

```ruby
catalog.collections.each do |collection|
  puts collection.id
end
collection = catalog.find_child('awesome_collection')

catalog.all_items.first(100).each do |item|
  puts item.id
end
item = catalog.find_item('awesome_item', recursive: true)
```

### STAC::Collection

`STAC::Collection` inherits `STAC::Catalog`.

The followings are `STAC::Collection` specific attributes:

- `attr_accessor license: String`
- `attr_accessor extent: STAC::Extent`
- `attr_accessor keywords: Array[String]?`
- `attr_accessor providers: Array[STAC::Provider]?`
- `attr_accessor summaries: Hash[String, untyped]?`
- `attr_reader assets: Hash[String, STAC::Asset]?`

To add an asset, use:

- `add_asset: (key: String, href: String, ?title: String?, ?description: String?, ?type: String?, ?roles: Array[String]?) -> self`

`STAC::Extent`, `STAC::Provider`, and `STAC::Asset` provide accessors for the corresponding object's fields.

```ruby
collection.extent.spatial.bbox = [-180, -90, 180, 90]
collection.extent.spatial.bbox #=> [-180, -90, 180, 90]
collection.extent.temporal.interval = ['2022-12-01T00:00:00Z', null]
collection.extent.temporal.interval #=> ["2022-12-01T00:00:00Z", null]

collection.providers << STAC::Provider.new(name: 'sankichi92')
collection.providers.last.name #=> "sankichi92"
```

See [STAC Collection Specification](https://github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md) for the details.

### STAC::Item

`STAC::Item` has the following attributes:

- `attr_accessor id: String`
- `attr_reader properties: STAC::Properties`
- `attr_reader assets: Hash[String, STAC::Asset]`
- `attr_accessor geometry: Hash[String, untyped]?`
- `attr_accessor bbox: Array[Numeric]?`
- `attr_accessor collection_id: String?`

And has the following methods:

- `add_asset: (key: String, href: String, ?title: String?, ?description: String?, ?type: String?, ?roles: Array[String]?) -> self`
- `collection: -> Collection?` returns a rel="collection" link as a collection object
- `collection=: (Collection collection) -> void` overwrites rel="collection" link and collection_id attribute

See [STAC Item Specification](https://github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md) for the details.

#### Common Metadata

`STAC::Properties` and `STAC::Asset` includes `STAC::CommonMetadata`, which provides read/write methods for [STAC Common Metadata](https://github.com/radiantearth/stac-spec/blob/master/item-spec/common-metadata.md) fields:

- `title: -> String?`
- `title=: (String) -> void`
- `description: -> String?`
- `description=: (String) -> void`
- `created: -> Time?`
- `created=: (Time | String) -> void`
- `updated: -> Time?`
- `updated=: (Time | String) -> void`
- `start_datetime: -> Time?`
- `start_datetime=: (Time | String) -> void`
- `end_datetime: -> Time?`
- `end_datetime=: (Time | String) -> void`
- `datetime_range: -> Range[Time]?` returns a range from #start_datetime to #end_datetime
- `datetime_range=: (Range[Time]) -> void` sets #start_datetime and #end_datetime by the given range
- `license: -> String?`
- `license=: (String) -> void`
- `providers: -> Array[Provider]`
- `providers=: (Array[Provider | Hash[String, untyped]]) -> void`
- `platform: -> String?`
- `platform=: (String) -> void`
- `instruments: -> Array[String]?`
- `instruments=: (Array[String]) -> void`
- `constellation: -> String?`
- `constellation=: (String) -> void`
- `mission: -> String?`
- `mission=: (String) -> void`
- `gsd: -> Numeric`
- `gsd=: (Numeric) -> void`

These methods are shorthand accessors of `#extra` hash:

```ruby
item.properties.extra #=> {}
item.properties.title = 'Awesome Item' # same as `item.properties.extra['title'] = 'Awesome Item'`
item.properties.title #=> "Awesome Item"
item.properties.extra #=> {"title"=>"Awesome Item"}
```

## Extensions

When an extension is added to a STAC object, methods corresponding to the extension will be added **dynamically** by [`Object#extend`](https://rubyapi.org/3.1/o/object#method-i-extend).

These methods are also shorthand accessors of `extra` hash same as `STAC::CommonMetadata`.

```ruby
item.stac_extensions #=> []
item.properties.extra #=> {}
item.properties.eo_cloud_cover #=> raises NoMethodError

item.add_extension('https://stac-extensions.github.io/eo/v1.0.0/schema.json')
# same as `item.add_extension(STAC::Extensions::ElectroOptical)`

item.stac_extensions #=> ["https://stac-extensions.github.io/eo/v1.0.0/schema.json"]
item.properties.eo_cloud_cover = 1.2
item.properties.eo_cloud_cover #=> 1.2
item.properties.extra #=> {"eo:cloud_cover"=>1.2}

# item.properties extends STAC::Extensions::ElectroOptical::Properties
item.properties.is_a?(STAC::Extensions::ElectroOptical::Properties) #=> true
```

Currently, only 4 stable extensions have been implemented:

```ruby
puts STAC::STACObject.extendables
# STAC::Extensions::ElectroOptical
# STAC::Extensions::Projection                                                             
# STAC::Extensions::ScientificCitation                                                     
# STAC::Extensions::ViewGeometry
```

### Adding Extensions

You can add custom extensions.

Extension modules must extend `STAC::Extension` and set `identifier` and `scope`.
And you must register it by `STAC::STACObject.add_extendable(extension_module)`.

```ruby
module MyExtension
  extend STAC::Extension

  identifier 'https://sankichi92.github.io/my_extension/v1.0.0/schema.json'
  scope STAC::Item, STAC::Collection
end

STAC::STACObject.add_extendable(MyExtension)
```

Then you can add methods to `STAC::Properties`, `STAC::Asset`, and `STAC::Collection` by defining modules with corresponding names **under the extension namespace**:

```ruby
module MyExtension
  module Properties
    def my_field
      extra['my:field']
    end

    def my_field(val)
      extra['my:field'] = val
    end
  end

  module Asset
    include Properties
  end
end
```

See [`lib/stac/extensions`](https://github.com/sankichi92/stac-ruby/tree/main/lib/stac/extensions) for examples.

## Using Custom HTTP Client

Custom HTTP client class must implement `get: (URI | String url) -> Hash[String, untyped]`, which returns response JSON as a Hash:

```ruby
class MyHTTPClient
  def get(url)
    # ...
  end
end
```

You can pass the custom HTTP client to `STAC.from_url` for a specific STAC object instance:

```ruby
catalog = STAC.from_url('https://example.com/catalog.json', http_client: MyHTTPClient.new)
```

Or you can set it as the global default by `STAC.default_http_client=`:

```ruby
STAC.default_http_client = MyHTTPClient.new
```

If you want to only add custom HTTP headers, you can use `STAC::SimpleHTTPClient`:

```ruby
http_client = STAC::SimpleHTTPClient.new({ 'X-Foo' => 'Bar' })
catalog = STAC.from_url('https://example.com/catalog.json', http_client:)
STAC.default_http_client = http_client
```
