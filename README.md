# stac-ruby

A Ruby library for working with [SpatioTemporal Asset Catalog (STAC)](https://stacspec.org/).\
See [satc-client-ruby](https://github.com/sankichi92/stac-client-ruby) for [STAC API](https://github.com/radiantearth/stac-api-spec) client.

This gem's implementation refers to [PySTAC](https://github.com/stac-utils/pystac).

### STAC Spec Version Support

v1.0.0

### STAC Extensions Support

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

[GETTING_STARTED.md](GETTING_STARTED.md)

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
