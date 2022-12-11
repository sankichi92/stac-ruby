## [Unreleased]

- Add extension modules from the current stable extensions (`ElectroOptical`, `Projection`, `ScientificCitation` and `ViewGeometry`).
- Make `STACObject` extend extension modules from `stac_extensions` value automatically.
- Introduce `HashLike` module and make STAC Object classes include it.
- Fix a bug that `Catalog#all_items` returns only direct children's items.
- Improve documentation.
- Add methods `#add_child` and `#add_item` to `STAC::Catalog`

## [0.2.0] - 2022-11-02

- Add `STAC::CommonMetadata` and make `Asset` and `Properties` include it.
- Make `http_client` instance variable of `STACObject` instead of class instance variable of `ObjectResolver`.
- Change `DefaultHTTPClient#get` return type: String => Hash (parsed JSON).
- Rename `DefaultHTTPClient` => `SimpleHTTPClient`.
- Enable to change the default HTTP client via `STAC.default_http_client`.

## [0.1.0] - 2022-10-09

- Initial release
