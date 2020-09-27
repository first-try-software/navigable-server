# Navigable::Server

[![Gem Version](https://badge.fury.io/rb/navigable-server.svg)](https://badge.fury.io/rb/navigable-server) [![Build Status](https://travis-ci.org/first-try-software/navigable-server.svg?branch=main)](https://travis-ci.org/first-try-software/navigable-server) [![Maintainability](https://api.codeclimate.com/v1/badges/e62e187bb05abe883169/maintainability)](https://codeclimate.com/github/first-try-software/navigable-server/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e62e187bb05abe883169/test_coverage)](https://codeclimate.com/github/first-try-software/navigable-server/test_coverage)

Navigable is a family of gems that together provide all the tools you need to build fast, testable, and reliable JSON and/or GraphQL based APIs with isolated, composable business logic. The gems include:

<table style="margin: 20px 0">
<tr height="140">
<td width="130"><img alt="Clipper Ship" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/clipper.png"></td>
<td>

**[Navigable][navigable]**<br>
A stand-alone tool for isolating business logic from external interfaces and cross-cutting concerns. Navigable composes self-configured command and observer objects to allow you to extend your business logic without modifying it. Navigable is compatible with any Ruby-based application development framework, including Rails, Hanami, and Sinatra.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Compass" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/sextant.png"></td>
<td>

**[Navigable Router][router]** *(coming soon)*<br>
A simple, highly-performant, Rack-based router.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Compass" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/compass.png"></td>
<td>

**[Navigable Server][server]** *(coming soon)*<br>
A Rack-based server for building Ruby and Navigable web applications.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Telescope" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/telescope.png"></td>
<td>

**Navigable API** *(coming soon)*<br>
An extension of Navigable Server for building restful JSON APIs.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Map" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/map.png"></td>
<td>

**Navigable GraphQL** *(coming soon)*<br>
An extension of Navigable Server for building GraphQL APIs.

</td>
</tr>
</table>

<br><br>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'navigable-server'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install navigable-server

## Usage

`Navigable::Server` is a different kind of server. Rather than registering routes in a route file, `Endpoint` classes register themselves at startup using the `responds_to` method. When the route is requested, `Navigable::Server` injects the `Request` into the `Endpoint` and calls the `execute` method.

```ruby
class AhoyEndpoint
  extend Navigable::Server::Endpoint

  responds_to :get, '/ahoy'

  def execute
    { status: 200, html: '<h1>Ahoy! Welcome aboard Navigable!</h1>' }
  end
end
```
The `execute` method should return a hash containing:

* Some content (either `json`, `html`, `text`, or `body`)
* An optional status code (default = 200)
* Optional headers (`Navigable::Server` sets `Content-Type` and `Content-Length` for you if they can be inferred)

Here are three examples:

```ruby
# returning successful creation of SomeActiveRecordModel
class CreateSomeActiveRecordModelEndpoint
  extend Navigable::Server::Endpoint

  responds_to :post, '/models'

  def execute
    model = SomeActiveRecordModel.create(request.params)
    { status: 201, json: model }
  end
end

# Returning 404 Not Found
class ShowSomeActiveRecordModelEndpoint
  extend Navigable::Server::Endpoint

  responds_to :get, '/models/:id'

  def execute
    model = SomeActiveRecordModel.find_by(id: request.params[:id])

    return { status: 404, text: 'Not Found' } unless model

    { json: model }
  end
end

# Returning an image
class ShowTreasureMapEndpoint
  extend Navigable::Server::Endpoint

  responds_to :get, '/treasure-map'

  def execute
    treasure_map = read_file('x_marks_the_spot.png')
    { headers: { 'Content-Type' => 'image/png' }, body: treasure_map }
  end
end
```
If you are considering creating a JSON API with `Navigable::Server`, you should know about `Navigable::API` and `Navigable::GraphQL`. Both of these gems extend `Navigable::Server` in ways that bring all of Navigable together from `Commands` and `Observers`, to `Endpoints` and `Resolvers`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/first-try-software/navigable-server. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/first-try-software/navigable-server/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Navigable::Server project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/first-try-software/navigable-server/blob/master/CODE_OF_CONDUCT.md).

[navigable]: https://github.com/first-try-software/navigable
[router]: https://github.com/first-try-software/navigable-router
[server]: https://github.com/first-try-software/navigable-server
