<p align="right"><a href="https://nuid.io"><img src="https://nuid.io/svg/logo.svg" width="20%"></a></p>

# NuID SDK for Ruby

This repo provides a Ruby Gem for interacting with NuID APIs within Ruby
applications.

Read the latest [gem
docs](https://rubydoc.info/gems/nuid-sdk/) or
checkout the [platform docs](https://portal.nuid.io/docs) for API docs, guides,
video tutorials, and more.

## Install

From [rubygems](https://rubygems.org/gems/nuid-sdk):

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

For a more detailed example visit the [Integrating with
NuID](https://portal.nuid.io/docs/guides/integrating-with-nuid) guide and the
accompanying [examples repo](https://github.com/NuID/examples).
A ruby-specific code example is coming soon.

```ruby
require "nuid-sdk"

class UsersController < ApplicationController
  NUID_API = ::NuID::SDK::API::Auth.new(ENV["NUID_API_KEY"])

  def register
    credential_res = NUID_API.credential_create(params[:verified_credential])
    if credential_res.ok?
      user_params = params.require(:email, :first_name, :last_name)
                          .merge({nuid: credential_res.body["nu/id"]})
      @current_user = User.create(user_params)
      render json: @current_user, status: :created
    else
      render status: :bad_request
    end
  end
end
```

## Development

You'll want to download docker to run the tests, as we depend on the
`@nuid/cli` npm package to provide a CLI you can shell out to
in the tests for generating zk crypto. After checking out the repo, run
`bin/setup` to install dependencies and create the docker environment. Then, run
`make test` to run the tests inside the running container. You can also run
`bin/console` for an interactive prompt that will allow you to experiment, but
you'll probably want to run that in the container (use `make shell` to get a
prompt in the container).

`make clean` will stop and destroy the container and image. `make build run`
will rebuild the image and run the container.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NuID/sdk-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
