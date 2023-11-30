# rspec-http-fixtures

Provides RSpec helper methods to build HTTP fixtures.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rspec-http-fixtures"
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install rspec-http-fixtures
```

## Usage

Within `rails_helper.rb`

```ruby
require "rspec-http-fixtures"

RSpec.configure do |config|
  # Specify where fixtures will be located
  config.http_fixtures_path = Rails.root.join("spec/fixtures")


  # Include helpers that are available within fixtures
  config.http_fixtures_include FixtureHelpers
end
```

Work with fixtures using the following helpers

```ruby
read_http_fixture("stripe/subscription.json.erb",
  id: "so_123",
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/axsuul/rspec-http-fixtures.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
