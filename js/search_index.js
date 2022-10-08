var search_data = {"index":{"searchIndex":["stac","asset","catalog","collection","defaulthttpclient","error","extent","spatial","temporal","httperror","item","link","objectresolver","provider","stacobject","typeerror","unknownurischemeerror","absolute_href()","add_link()","children()","collections()","default_http_client()","find_child()","from_file()","from_hash()","from_hash()","from_hash()","from_hash()","from_hash()","from_hash()","from_hash()","from_hash()","from_hash()","from_url()","get()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","resolve()","self_href()","self_href=()","target()","to_h()","to_h()","to_h()","to_h()","to_h()","to_h()","to_h()","to_h()","to_h()","to_h()","to_json()","type()","changelog","readme"],"longSearchIndex":["stac","stac::asset","stac::catalog","stac::collection","stac::defaulthttpclient","stac::error","stac::extent","stac::extent::spatial","stac::extent::temporal","stac::httperror","stac::item","stac::link","stac::objectresolver","stac::provider","stac::stacobject","stac::typeerror","stac::unknownurischemeerror","stac::link#absolute_href()","stac::stacobject#add_link()","stac::catalog#children()","stac::catalog#collections()","stac::objectresolver::default_http_client()","stac::catalog#find_child()","stac::from_file()","stac::asset::from_hash()","stac::collection::from_hash()","stac::extent::from_hash()","stac::extent::spatial::from_hash()","stac::extent::temporal::from_hash()","stac::item::from_hash()","stac::link::from_hash()","stac::provider::from_hash()","stac::stacobject::from_hash()","stac::from_url()","stac::defaulthttpclient#get()","stac::asset::new()","stac::catalog::new()","stac::collection::new()","stac::defaulthttpclient::new()","stac::extent::new()","stac::extent::spatial::new()","stac::extent::temporal::new()","stac::item::new()","stac::link::new()","stac::objectresolver::new()","stac::provider::new()","stac::stacobject::new()","stac::objectresolver#resolve()","stac::stacobject#self_href()","stac::stacobject#self_href=()","stac::link#target()","stac::asset#to_h()","stac::catalog#to_h()","stac::collection#to_h()","stac::extent#to_h()","stac::extent::spatial#to_h()","stac::extent::temporal#to_h()","stac::item#to_h()","stac::link#to_h()","stac::provider#to_h()","stac::stacobject#to_h()","stac::stacobject#to_json()","stac::stacobject#type()","",""],"info":[["STAC","","STAC.html","","<p>Gem namespace.\n<p>Provides some utility methods.\n"],["STAC::Asset","","STAC/Asset.html","","<p>Represents STAC asset object, which contains a link to data associated with an Item or Collection that …\n"],["STAC::Catalog","","STAC/Catalog.html","","<p>Represents STAC catalog.\n<p>Spec: github.com/radiantearth/stac-spec/tree/master/catalog-spec\n"],["STAC::Collection","","STAC/Collection.html","","<p>Represents STAC collection.\n<p>Spec: github.com/radiantearth/stac-spec/tree/master/collection-spec\n"],["STAC::DefaultHTTPClient","","STAC/DefaultHTTPClient.html","","<p>Simple HTTP Client using OpenURI.\n"],["STAC::Error","","STAC/Error.html","",""],["STAC::Extent","","STAC/Extent.html","","<p>Represents STAC extent object, which describes the spatio-temporal extents of a Collection.\n<p>Spec: github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md#extent-object …\n"],["STAC::Extent::Spatial","","STAC/Extent/Spatial.html","","<p>Describes the spatial extents of a Collection\n"],["STAC::Extent::Temporal","","STAC/Extent/Temporal.html","","<p>Describes the temporal extents of a Collection.\n"],["STAC::HTTPError","","STAC/HTTPError.html","",""],["STAC::Item","","STAC/Item.html","","<p>Represents STAC item.\n<p>Spec: github.com/radiantearth/stac-spec/tree/master/item-spec\n"],["STAC::Link","","STAC/Link.html","","<p>Represents STAC link object, which describes a relationship with another entity.\n"],["STAC::ObjectResolver","","STAC/ObjectResolver.html","","<p>Resolves a STAC object from a URL.\n"],["STAC::Provider","","STAC/Provider.html","","<p>Represents STAC provider object, which provides information about a provider.\n<p>Spec: github.com/radiantearth/stac-spec/blob/master/collection-spec/collection-spec.md#provider-object …\n"],["STAC::STACObject","","STAC/STACObject.html","","<p>Base class for STAC objects.\n"],["STAC::TypeError","","STAC/TypeError.html","",""],["STAC::UnknownURISchemeError","","STAC/UnknownURISchemeError.html","",""],["absolute_href","STAC::Link","STAC/Link.html#method-i-absolute_href","()","<p>Returns the absolute HREF for this link.\n<p>When it could not assemble the absolute HREF, it returns nil. …\n"],["add_link","STAC::STACObject","STAC/STACObject.html#method-i-add_link","(link)","<p>Adds a link with setting its ‘owner` as self.\n"],["children","STAC::Catalog","STAC/Catalog.html#method-i-children","()","<p>Returns rel=“child” objects of this catalog.\n"],["collections","STAC::Catalog","STAC/Catalog.html#method-i-collections","()","<p>Returns child Collections of this catalog.\n"],["default_http_client","STAC::ObjectResolver","STAC/ObjectResolver.html#method-c-default_http_client","()",""],["find_child","STAC::Catalog","STAC/Catalog.html#method-i-find_child","(id)","<p>Returns the child Catalog/Collection with the given ID.\n"],["from_file","STAC","STAC.html#method-c-from_file","(path)","<p>Returns a STAC object resolved from the given file path.\n"],["from_hash","STAC::Asset","STAC/Asset.html#method-c-from_hash","(hash)","<p>Deserializes an Asset from a Hash.\n"],["from_hash","STAC::Collection","STAC/Collection.html#method-c-from_hash","(hash)",""],["from_hash","STAC::Extent","STAC/Extent.html#method-c-from_hash","(hash)","<p>Deserializes an Extent from a Hash.\n"],["from_hash","STAC::Extent::Spatial","STAC/Extent/Spatial.html#method-c-from_hash","(hash)","<p>Deserializes a Spatial from a Hash.\n"],["from_hash","STAC::Extent::Temporal","STAC/Extent/Temporal.html#method-c-from_hash","(hash)","<p>Deserializes a Temporal from a Hash.\n"],["from_hash","STAC::Item","STAC/Item.html#method-c-from_hash","(hash)",""],["from_hash","STAC::Link","STAC/Link.html#method-c-from_hash","(hash)","<p>Deserializes a Link from a Hash.\n"],["from_hash","STAC::Provider","STAC/Provider.html#method-c-from_hash","(hash)","<p>Deserializes a Provider from a Hash.\n"],["from_hash","STAC::STACObject","STAC/STACObject.html#method-c-from_hash","(hash)","<p>Deserializes a STAC Object from a Hash.\n<p>Raises ArgumentError when any required fields are missing.\n"],["from_url","STAC","STAC.html#method-c-from_url","(url, resolver: ObjectResolver.new)","<p>Returns a STAC object resolved from the given URL.\n<p>When the resolved object does not have rel=“self” …\n"],["get","STAC::DefaultHTTPClient","STAC/DefaultHTTPClient.html#method-i-get","(uri)","<p>Makes a HTTP request and returns the response body as String.\n<p>Raises STAC::HTTPError when the response …\n"],["new","STAC::Asset","STAC/Asset.html#method-c-new","(href:, title: nil, description: nil, type: nil, roles: nil, **extra)",""],["new","STAC::Catalog","STAC/Catalog.html#method-c-new","(id:, description:, links:, title: nil, stac_extensions: nil, **extra)",""],["new","STAC::Collection","STAC/Collection.html#method-c-new","( id:, description:, links:, license:, extent:, title: nil, keywords: nil, providers: nil, summaries: nil, assets: nil, stac_extensions: nil, **extra )",""],["new","STAC::DefaultHTTPClient","STAC/DefaultHTTPClient.html#method-c-new","(options = { 'User-Agent' => \"stac-ruby v#{VERSION}\" })",""],["new","STAC::Extent","STAC/Extent.html#method-c-new","(spatial:, temporal:, **extra)",""],["new","STAC::Extent::Spatial","STAC/Extent/Spatial.html#method-c-new","(bbox:, **extra)",""],["new","STAC::Extent::Temporal","STAC/Extent/Temporal.html#method-c-new","(interval:, **extra)",""],["new","STAC::Item","STAC/Item.html#method-c-new","( id:, geometry:, properties:, links:, assets:, bbox: nil, collection: nil, stac_extensions: nil, **extra )",""],["new","STAC::Link","STAC/Link.html#method-c-new","(rel:, href:, type: nil, title: nil, **extra)",""],["new","STAC::ObjectResolver","STAC/ObjectResolver.html#method-c-new","(http_client: self.class.default_http_client)",""],["new","STAC::Provider","STAC/Provider.html#method-c-new","(name:, description: nil, roles: nil, url: nil, **extra)",""],["new","STAC::STACObject","STAC/STACObject.html#method-c-new","(id:, links:, stac_extensions: nil, **extra)",""],["resolve","STAC::ObjectResolver","STAC/ObjectResolver.html#method-i-resolve","(url)","<p>Reads a JSON from the given URL and returns a STAC object resolved from it.\n<p>Supports the following URL …\n"],["self_href","STAC::STACObject","STAC/STACObject.html#method-i-self_href","()","<p>Reterns HREF of the rel=“self” link.\n"],["self_href=","STAC::STACObject","STAC/STACObject.html#method-i-self_href-3D","(absolute_href)","<p>Adds a link with the give HREF as rel=“self”.\n<p>When ref=“self” links already exist, …\n"],["target","STAC::Link","STAC/Link.html#method-i-target","()","<p>Returns a STAC object resolved from HREF.\n<p>When it could not assemble the absolute HREF, it returns nil. …\n"],["to_h","STAC::Asset","STAC/Asset.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Catalog","STAC/Catalog.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Collection","STAC/Collection.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Extent","STAC/Extent.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Extent::Spatial","STAC/Extent/Spatial.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Extent::Temporal","STAC/Extent/Temporal.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Item","STAC/Item.html#method-i-to_h","()",""],["to_h","STAC::Link","STAC/Link.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::Provider","STAC/Provider.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_h","STAC::STACObject","STAC/STACObject.html#method-i-to_h","()","<p>Serializes self to a Hash.\n"],["to_json","STAC::STACObject","STAC/STACObject.html#method-i-to_json","(...)","<p>Serializes self to a JSON string.\n"],["type","STAC::STACObject","STAC/STACObject.html#method-i-type","()",""],["CHANGELOG","","CHANGELOG_md.html","","<p>[Unreleased]\n<p>[0.1.0] - 2022-09-09\n<p>Initial release\n"],["README","","README_md.html","","<p>stac-ruby\n<p>A Ruby library for working with SpatioTemporal Asset Catalog (STAC).\n<p>This gem’s implementation …\n"]]}}