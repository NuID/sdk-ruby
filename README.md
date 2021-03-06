<p align="right"><a href="https://nuid.io"><img src="https://nuid.io/svg/logo.svg" width="20%"></a></p>

# NuID SDK for Ruby

[![](https://img.shields.io/gem/v/nuid-sdk?color=red&logo=rubygems&style=for-the-badge)](https://rubygems.org/gems/nuid-sdk)
[![](https://img.shields.io/badge/docs-v0.2.0-blue?style=for-the-badge&logo=read-the-docs)](https://rubydoc.info/gems/nuid-sdk)
[![](https://img.shields.io/badge/docs-platform-purple?style=for-the-badge&logo=read-the-docs)](https://portal.nuid.io/docs)

This repo provides a Ruby Gem for interacting with NuID APIs within Ruby
applications.

Read the latest [gem
docs](https://rubydoc.info/gems/nuid-sdk/) or
checkout the [platform docs](https://portal.nuid.io/docs) for API docs, guides,
video tutorials, and more.

## Install

From [rubygems](https://rubygems.org/gems/nuid-sdk):

```sh
gem install nuid-sdk -v "0.2.0"
```

Or with bundler:

```ruby
# Gemfile
gem "nuid-sdk", "~> 0.2"
```

## Usage

Example rails auth controller.

For a more detailed example visit the [Integrating with
NuID](https://portal.nuid.io/docs/guides/integrating-with-nuid) guide and the
accompanying [examples repo](https://github.com/NuID/examples).
A ruby-specific code example is coming soon.

``` ruby
# config/application.rb
config.x.nuid.auth_api_key = ENV['NUID_API_KEY']
```

``` ruby
require "nuid/sdk/api/auth"

class ApplicationController < ActionController::API
  def nuid_api
    @nuid_api ||= ::NuID::SDK::API::Auth.new(Rails.configuration.x.nuid.auth_api_key)
  end

  def render_error(error, status)
    render(json: {errors: [error]}, status: status)
  end
end
```

```ruby
class UsersController < ApplicationController
  NUID_API = ::NuID::SDK::API::Auth.new(ENV["NUID_API_KEY"])

  # The registration form should send the verified credential to be
  # recorded in the NuID Auth API. The response to that interaction
  # will provide a `nu/id` key in the response which should be stored
  # with the newly created user record.
  #
  # The "verified credential" is generated by your client application
  # using `Zk.verifiableFromSecret(password)` from the `@nuid/zk` npm
  # package.
  def register
    credential_res = nuid_api.credential_create(params[:credential])
    unless credential_res.code == 201
      return render_error("Unable to create the credential", :bad_request)
    end

    user = User.create!({
      email: params[:email].strip.downcase,
      first_name: params[:firstName],
      last_name: params[:lastName],
      nuid: credential_res.parsed_response["nu/id"]
    })

    render(json: { user: user }, status: :created)
  rescue => exception
    render_error(exception.message, 500)
  end
end
```

``` ruby
class SessionsController < ApplicationController
  NUID_API = ::NuID::SDK::API::Auth.new(ENV["NUID_API_KEY"])

  # Get a challenge from the Auth API. The client form should request
  # a challenge as the first of two phases to login. Once a succesful
  # challenge has been fetched, return it to the client so a proof
  # can be generated from the challenge claims and the user's password.
  def login_challenge
    user = User.where(email: params[:email].strip.downcase).first
    return render_error("User not found", :unauthorized) unless user

    credential_res = nuid_api.credential_get(user.nuid)
    unless credential_res.code == 200
      return render_error("Credential not found", :unauthorized)
    end

    credential = credential_res.parsed_response["nuid/credential"]
    challenge_res = nuid_api.challenge_get(credential)
    unless challenge_res.code == 201
      return render_error("Cannot create a challenge", 500)
    end

    challenge_jwt = challenge_res.parsed_response["nuid.credential.challenge/jwt"]
    render(json: { challengeJwt: challenge_jwt }, status: :ok)
  rescue => exception
    render_error(exception.message, 500)
  end

  # Verify is the second part of the login process. The params
  # provided here include the user identification param (email or
  # username), the unaltered challenge_jwt retrieved in phase 1 of login
  # (see #login_challenge above), and the proof that was generated from
  # the challenge_jwt claims and the user secret.
  #
  # The "proof" is generated by your client application using
  # `Zk.proofFromSecretAndChallenge(password, challenge_jwt)` from the
  # `@nuid/zk` npm package.
  def login_verify
    user = User.where(email: params[:email].strip.downcase).first
    return render_error("User not found", :unauthorized) unless user

    challenge_res = nuid_api.challenge_verify(params[:challengeJwt], params[:proof])
    unless challenge_res.code == 200
      return render_error("Verification failed", :unauthorized)
    end

    render(json: { user: user }, status: :ok)
  rescue => exception
    render_error(exception.message, 500)
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
