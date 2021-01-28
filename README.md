<p align="right"><a href="https://nuid.io"><img src="https://nuid.io/svg/logo.svg" width="20%"></a></p>

# NuID SDK for Ruby

This repo provides a Ruby Gem for interacting with NuID APIs within Ruby
applications.

Read the latest [package
docs](http://libdocs.s3-website-us-east-1.amazonaws.com/sdk-ruby/v0.1.0/) or
checkout the [platform docs](https://portal.nuid.io/docs) for API docs, guides,
video tutorials, and more.

## Install

With [gem](https://www.npmjs.com/package/@nuid/sdk-nodejs):

```sh
gem install nuid-sdk -v "0.1.0"
```

Or with bundler:

```ruby
# Gemfile
gem "nuid-sdk", "~> 0.1.0"
```

## Usage

Example rails auth controller.

For a more detailed example visit the [Integrating with NuID](https://portal.nuid.io/docs/guides/integrating-with-nuid) guide and its
accompanying repository
[node-example](https://github.com/NuID/node-example/tree/bj/client-server-apps).
A ruby-specific code example is coming soon.

```ruby
require "nuid-sdk"

class UsersController < ApplicationController
  NUID_API = ::NuID::SDK::API::Auth.new(ENV["NUID_API_KEY"])

  def register
    credential = NUID_API.credential_create(params[:verified_credential])
    user_params = params.require(:email, :first_name, :last_name)
                        .merge({nuid: credential["nu/id"]})
    @current_user = User.create(user_params)
  end
end
```
]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NuID/sdk-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
