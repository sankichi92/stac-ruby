## [Unreleased]

- Add `STAC::CommonMetadata` and make `Asset` and `Properties` include it.
- Make `http_client` instance variable of `STACObject` instead of class instance variable of `ObjectResolver`.
- Change `DefaultHTTPClient#get` return type: String => Hash (parsed JSON).
- Rename `DefaultHTTPClient` => `SimpleHTTPClient`.
- Enable to change the default HTTP client via `STAC.default_http_client`.

## [0.1.0] - 2022-10-09

- Initial release
